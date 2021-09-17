from contextlib import (
    suppress,
)
from functools import (
    partial,
)
import json
import operator
from os import (
    environ,
    getcwd,
    makedirs,
    remove,
)
from os.path import (
    exists,
    isdir,
    join,
)
from posixpath import (
    abspath,
    dirname,
)
import re
import shutil
import subprocess  # nosec
import sys
import tempfile
from typing import (
    Any,
    Callable,
    Dict,
    List,
    Optional,
    Set,
    Tuple,
)
from urllib.parse import (
    quote_plus as url_quote,
)
from uuid import (
    uuid4 as uuid,
)

CWD: str = getcwd()
OUT_BASE: str = tempfile.mkdtemp()
ON_EXIT: List[Callable[[], None]] = [
    partial(shutil.rmtree, OUT_BASE, ignore_errors=True)
]
VERSION: str = "21.10"

# Environment
__MAKES_SRC__: str = environ["__MAKES_SRC__"]
__NIX_STABLE__: str = environ["__NIX_STABLE__"]
__NIX_UNSTABLE__: str = environ["__NIX_UNSTABLE__"]


def _log(*args: str) -> None:
    print(*args, file=sys.stderr)


# Feature flags
NIX_STABLE: bool = not bool(environ.get("NIX_UNSTABLE"))
if not NIX_STABLE:
    _log("Using feature flag: NIX_UNSTABLE")
    _log()


class Error(Exception):
    pass


def _if(condition: Any, *value: Any) -> List[Any]:
    return list(value) if condition else []


def _clone_src(src: str) -> str:
    remote: str
    head = tempfile.TemporaryDirectory(prefix="makes-").name
    ON_EXIT.append(partial(shutil.rmtree, head, ignore_errors=True))

    if is_src_local(src):
        remote = abspath(src)
        rev = "HEAD"

    elif match := re.match(
        r"^github:(?P<owner>.*)/(?P<repo>.*)@(?P<rev>.*)$", src
    ):
        owner = url_quote(match.group("owner"))
        repo = url_quote(match.group("repo"))
        rev = url_quote(match.group("rev"))
        remote = f"https://github.com/{owner}/{repo}"

    elif match := re.match(
        r"^gitlab:(?P<owner>.*)/(?P<repo>.*)@(?P<rev>.*)$", src
    ):
        owner = url_quote(match.group("owner"))
        repo = url_quote(match.group("repo"))
        rev = url_quote(match.group("rev"))
        remote = f"https://gitlab.com/{owner}/{repo}.git"

    else:
        raise Error(f"Unable to parse [SOURCE]: {src}")

    out, stdout, stderr = _run(
        ["git", "init", "--initial-branch=____", "--shared=false", head]
    )
    if out != 0:
        raise Error(f"Unable to git init: {src}", stdout, stderr)

    out, stdout, stderr = _run(
        ["git", "-C", head, "fetch", "--depth=1", remote, f"{rev}:{rev}"]
    )
    if out != 0:
        raise Error(f"Unable to git fetch: {src}", stdout, stderr)

    out, stdout, stderr = _run(["git", "-C", head, "checkout", rev])
    if out != 0:
        raise Error(f"Unable to git checkout: {src}", stdout, stderr)

    return head


def is_src_local(src: str) -> bool:
    return isdir(src)


def _nix_build(
    *,
    attr: str,
    cache: Optional[List[Dict[str, str]]],
    head: str,
    out: str = "",
    src: str,
) -> List[str]:
    if cache is None:
        substituters = "https://cache.nixos.org"
        trusted_pub_keys = (
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        )
    else:
        substituters = " ".join(map(operator.itemgetter("url"), cache))
        trusted_pub_keys = " ".join(map(operator.itemgetter("pubKey"), cache))

    return [
        *_if(NIX_STABLE, f"{__NIX_STABLE__}/bin/nix-build"),
        *_if(not NIX_STABLE, f"{__NIX_UNSTABLE__}/bin/nix"),
        *_if(not NIX_STABLE, "--experimental-features", "flakes nix-command"),
        *_if(not NIX_STABLE, "build"),
        *_if(NIX_STABLE, "--argstr", "makesExecutionId", uuid().hex),
        *_if(NIX_STABLE, "--argstr", "makesSrc", __MAKES_SRC__),
        *_if(NIX_STABLE, "--argstr", "projectSrc", head),
        *_if(NIX_STABLE and is_src_local(src), "--argstr"),
        *_if(NIX_STABLE and is_src_local(src), "projectSrcMutable", src),
        *_if(NIX_STABLE, "--attr", attr),
        *["--option", "cores", "0"],
        *["--option", "narinfo-cache-negative-ttl", "1"],
        *["--option", "narinfo-cache-positive-ttl", "1"],
        *["--option", "max-jobs", "auto"],
        *["--option", "substituters", substituters],
        *["--option", "trusted-public-keys", trusted_pub_keys],
        *["--option", "sandbox", "true"],
        *_if(out, "--out-link", out),
        *_if(not out, "--no-out-link"),
        *["--show-trace"],
        *_if(NIX_STABLE, f"{__MAKES_SRC__}/src/evaluator/default.nix"),
        *_if(not NIX_STABLE, attr),
    ]


def _get_head(src: str) -> str:
    # Checkout repository HEAD into a temporary directory
    # This is nice for reproducibility and security,
    # files not in the HEAD commit are left out of the build inputs
    head: str = _clone_src(src)

    # Applies only to local repositories
    if is_src_local(src):
        paths: Set[str] = set()

        # Propagated `git add`ed files
        out, stdout, stderr = _run(
            ["git", "-C", src, "diff", "--cached", "--name-only"]
        )
        if out != 0:
            raise Error(f"Unable to list files: {src}", stdout, stderr)
        paths.update(stdout.decode().splitlines())

        # Propagated modified files
        out, stdout, stderr = _run(
            ["git", "-C", src, "ls-files", "--modified"]
        )
        if out != 0:
            raise Error(f"Unable to list files: {src}", stdout, stderr)
        paths.update(stdout.decode().splitlines())

        # Copy paths to head
        for path in sorted(paths):
            dest = join(head, path)
            path = join(src, path)
            if not exists(dirname(dest)):
                makedirs(dirname(dest))
            if exists(path):
                shutil.copy(path, dest)
            else:
                remove(dest)

    shutil.rmtree(join(head, ".git"))
    return head


def _get_attrs(src: str, head: str) -> List[str]:
    out: str = tempfile.mktemp()  # nosec
    code, stdout, stderr, = _run(
        args=_nix_build(
            attr="config.attrs"
            if NIX_STABLE
            else f'{head}#"makes:config:attrs"',
            cache=None,
            head=head,
            out=out,
            src=src,
        ),
    )
    if code == 0:
        with open(out) as file:
            return json.load(file)

    raise Error(f"Unable to list project outputs from: {src}", stdout, stderr)


def _get_cache(src: str, head: str) -> List[Dict[str, str]]:
    out: str = tempfile.mktemp()  # nosec
    code, stdout, stderr, = _run(
        args=_nix_build(
            attr="config.cacheAsJson"
            if NIX_STABLE
            else f'{head}#"makes:config:cacheAsJson"',
            cache=None,
            head=head,
            out=out,
            src=src,
        ),
    )

    if code == 0:
        with open(out) as file:
            return json.load(file)

    raise Error(f"Unable to get cache config from: {src}", stdout, stderr)


def _run(
    args: List[str],
    cwd: Optional[str] = None,
    env: Optional[Dict[str, str]] = None,
    capture_io: bool = True,
    stdin: Optional[bytes] = None,
) -> Tuple[int, bytes, bytes]:
    with subprocess.Popen(
        args=args,
        cwd=cwd,
        env=env,
        shell=False,  # nosec
        stdin=None if stdin is None else subprocess.PIPE,
        stdout=subprocess.PIPE if capture_io else None,
        stderr=subprocess.PIPE if capture_io else None,
    ) as process:
        out, err = process.communicate(stdin)

    return process.returncode, out, err


def _help_and_exit(
    src: Optional[str] = None,
    attrs: Optional[List[str]] = None,
    exc: Optional[Exception] = None,
) -> None:
    _log("Usage: m [SOURCE] [OUTPUT] [ARGS]...")
    if src:
        _log()
        _log(f"[SOURCE] is currently: {src}")
    else:
        _log()
        _log("[SOURCE] can be:")
        _log()
        _log("  A local Git repository:")
        _log("    /path/to/local/repository")
        _log("    ./relative/path")
        _log("    .")
        _log()
        _log("  A GitHub repository and revision (branch, commit or tag):")
        _log("    github:owner/repo@rev")
        _log()
        _log("  A GitLab repository and revision (branch, commit or tag):")
        _log("    gitlab:owner/repo@rev")
    if attrs is None:
        _log()
        _log("[OUTPUT] options will be listed when you provide a [SOURCE]")
    else:
        _log()
        _log("[OUTPUT] can be:")
        for attr in attrs:
            if attr not in {
                "__all__",
                "/secretsForAwsFromEnv/__default__",
            }:
                _log(f"  {attr}")
    if exc is not None:
        _log()
        raise exc

    _log()
    _log("[ARGS] are passed to the output (if supported).")

    raise SystemExit(1)


def cli(args: List[str]) -> None:
    _log(f"Makes v{VERSION}-{sys.platform}")
    _log()
    if not args[1:]:
        _help_and_exit()

    src: str = args[1]
    if not args[2:]:
        try:
            head: str = _get_head(src)
            attrs: List[str] = _get_attrs(src, head)
        except Error as exc:
            _help_and_exit(src, exc=exc)
        else:
            _help_and_exit(src, attrs)

    attr: str = args[2]
    args = args[3:]
    head = _get_head(src)
    attrs = _get_attrs(src, head)
    if attr not in attrs:
        _help_and_exit(src, attrs)

    out: str = join(OUT_BASE, f"result{attr.replace('/', '-')}")

    cache: List[Dict[str, str]] = _get_cache(src, head)
    code, _, _ = _run(
        args=_nix_build(
            attr=f'config.outputs."{attr}"'
            if NIX_STABLE
            else f'{head}#makes:config:outputs:"{attr}"',
            cache=cache,
            head=head,
            out=out,
            src=src,
        ),
        capture_io=False,
    )

    if code == 0:
        cache_push(cache, out)
        execute_action(args, head, out, src)

    raise SystemExit(code)


def execute_action(args: List[str], head: str, out: str, src: str) -> None:
    action_path: str = join(out, "makes-action.sh")

    if exists(action_path):
        code, _, _ = _run(
            args=[action_path, out, *args],
            capture_io=False,
            cwd=src if is_src_local(src) else head,
        )
        raise SystemExit(code)


def cache_push(cache: List[Dict[str, str]], out: str) -> None:
    for config in cache:
        if config["type"] == "cachix" and "CACHIX_AUTH_TOKEN" in environ:
            _log("Pushing to cache")
            _, stdout, _ = _run(["nix-store", "-qR", out])
            _run(
                args=["cachix", "push", "-c", "0", config["name"]],
                capture_io=False,
                stdin=stdout,
            )
            return


def main() -> None:
    try:
        cli(sys.argv)
    except Error as err:
        _log(f"[ERROR] {err.args[0]}")
        if err.args[1:]:
            _log(f"[ERROR] Stdout: \n{err.args[1].decode(errors='replace')}")
        if err.args[2:]:
            _log(f"[ERROR] Stderr: \n{err.args[2].decode(errors='replace')}")
        sys.exit(1)
    except SystemExit as err:
        sys.exit(err.code)


def cleanup() -> None:
    for action in ON_EXIT:
        with suppress(BaseException):
            action()


if __name__ == "__main__":
    try:
        main()
    finally:
        cleanup()
