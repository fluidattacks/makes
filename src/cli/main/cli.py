from contextlib import (
    suppress,
)
import emojis
from functools import (
    partial,
)
from glob import (
    glob,
)
from hashlib import (
    sha256,
)
import io
import json
import os
from os import (
    environ,
    getcwd,
    getlogin,
    makedirs,
    remove,
)
from os.path import (
    exists,
    getctime,
    join,
    realpath,
)
from posixpath import (
    abspath,
    dirname,
)
import random
import re
import rich.align
import rich.console
import rich.markup
import rich.panel
import rich.table
import rich.text
import shlex
import shutil
from socket import (
    gethostname,
)
import subprocess  # nosec
import sys
import tempfile
import textwrap
from time import (
    time,
)
from tui import (
    TextUserInterface,
)
from typing import (
    Any,
    Callable,
    Dict,
    List,
    NamedTuple,
    Optional,
    Set,
    Tuple,
)
from urllib.parse import (
    quote_plus as url_quote,
)
import warnings

CWD: str = getcwd()
CON: rich.console.Console = rich.console.Console(
    highlight=False,
    file=io.TextIOWrapper(sys.stderr.buffer, write_through=True),
)
MAKES_DIR: str = join(environ["HOME_IMPURE"], ".cache/makes")
makedirs(MAKES_DIR, exist_ok=True)
SOURCES_CACHE: str = join(MAKES_DIR, "sources")
ON_EXIT: List[Callable[[], None]] = []
VERSION: str = "24.12"

# Environment
__MAKES_SRC__: str = environ["__MAKES_SRC__"]
__NIX__: str = environ["__NIX__"]


# Feature flags
AWS_BATCH_COMPAT: bool = bool(environ.get("MAKES_AWS_BATCH_COMPAT"))
if AWS_BATCH_COMPAT:
    CON.out("Using feature flag: MAKES_AWS_BATCH_COMPAT")
    CON.out()

GIT_DEPTH: int = int(environ.get("MAKES_GIT_DEPTH", "3"))
if GIT_DEPTH != 3:
    CON.out(f"Using feature flag: MAKES_GIT_DEPTH={GIT_DEPTH}")


def _if(condition: Any, *value: Any) -> List[Any]:
    return list(value) if condition else []


def _clone_src(src: str) -> str:
    # pylint: disable=consider-using-with
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        head = tempfile.TemporaryDirectory(prefix="makes-").name
    ON_EXIT.append(partial(shutil.rmtree, head, ignore_errors=True))

    if abspath(src) == CWD:  # `m .` ?
        _clone_src_git_worktree_add(src, head)
    else:
        if (
            (match := _clone_src_github(src))
            or (match := _clone_src_gitlab(src))
            or (match := _clone_src_local(src))
        ):
            cache_key, remote, rev = match
        else:
            CON.print(f"We can't proceed with SOURCE: {src}", justify="center")
            CON.print("It has an unrecognized format", justify="center")
            CON.print()
            CON.print("Please see the correct usage below", justify="center")
            _help_and_exit_base()

        _clone_src_git_init(head)
        remote = _clone_src_cache_get(src, cache_key, remote)
        _clone_src_git_fetch(head, remote, rev)
        _clone_src_git_checkout(head, rev)
        _clone_src_cache_refresh(head, cache_key)

    return head


def _clone_src_git_init(head: str) -> None:
    cmd = ["git", "init", "--initial-branch=____", "--shared=false", head]
    out = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)


def _clone_src_git_rev_parse(head: str, rev: str) -> str:
    cmd = ["git", "-C", head, "rev-parse", rev]
    out, stdout, _ = _run_outputs(cmd, stderr=None)
    if out != 0:
        raise SystemExit(out)

    return next(iter(stdout.decode().splitlines()), "HEAD")


def _clone_src_git_fetch(head: str, remote: str, rev: str) -> None:
    depth = _if(GIT_DEPTH >= 1, f"--depth={GIT_DEPTH}")
    cmd = ["git", "-C", head, "fetch", *depth, remote, f"{rev}:{rev}"]
    out = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)


def _clone_src_git_checkout(head: str, rev: str) -> None:
    cmd = ["git", "-C", head, "checkout", rev]
    out = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)


def _clone_src_git_worktree_add(remote: str, head: str) -> None:
    cmd = ["git", "-C", remote, "worktree", "add", head, "HEAD"]
    out = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)
    CON.out(head)


def _clone_src_github(src: str) -> Optional[Tuple[str, str, str]]:
    regex = r"^github:(?P<owner>.*)/(?P<repo>.*)@(?P<rev>.*)$"

    if match := re.match(regex, src):
        owner = url_quote(match.group("owner"))
        repo = url_quote(match.group("repo"))
        rev = url_quote(match.group("rev"))
        remote = f"https://github.com/{owner}/{repo}"
        cache_key = f"github-{owner}-{repo}-{rev}"

        return cache_key, remote, rev

    return None


def _clone_src_gitlab(src: str) -> Optional[Tuple[str, str, str]]:
    regex = r"^gitlab:(?P<owner>.*)/(?P<repo>.*)@(?P<rev>.*)$"

    if match := re.match(regex, src):
        owner = url_quote(match.group("owner"))
        repo = url_quote(match.group("repo"))
        rev = url_quote(match.group("rev"))
        remote = f"https://gitlab.com/{owner}/{repo}.git"
        cache_key = f"gitlab-{owner}-{repo}-{rev}"

        return cache_key, remote, rev

    return None


def _clone_src_local(src: str) -> Optional[Tuple[str, str, str]]:
    regex = r"^local:(?P<path>.*)@(?P<rev>.*)$"

    if match := re.match(regex, src):
        path = url_quote(match.group("path"))
        rev = url_quote(match.group("rev"))
        remote = f"file://{path}"
        cache_key = ""

        return cache_key, remote, rev

    return None


def _clone_src_cache_get(src: str, cache_key: str, remote: str) -> str:
    cached: str = join(SOURCES_CACHE, cache_key)
    if cache_key:
        if exists(cached):
            cached_since: float = time() - getctime(cached)
            if cached_since <= 86400.0:
                CON.out(f"Cached from {cached}")
                remote = cached
            else:
                shutil.rmtree(cached)
        else:
            CON.out(f"From {src}")

    return remote


def _clone_src_cache_refresh(head: str, cache_key: str) -> None:
    cached: str = join(SOURCES_CACHE, cache_key)
    if cache_key and not exists(cached):
        shutil.copytree(head, cached)


def _get_attr_paths(head: str) -> str:
    rel_paths: list[str] = glob("**/main.nix", root_dir=head, recursive=True)
    abs_paths: list[str] = [f"/{path}" for path in rel_paths]
    return json.dumps({"attrs": abs_paths}, separators=(",", ":"))


def _nix_build(
    *,
    attr: str,
    attr_paths: str,
    cache: Optional[List[Dict[str, str]]],
    head: str,
    out: str = "",
) -> List[str]:
    if cache is None:
        substituters = "https://cache.nixos.org"
        trusted_pub_keys = (
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        )
    else:
        substituters = " ".join(
            [
                item["url"]
                for item in cache
                if "url" in item and "pubKey" in item and item["url"]
            ]
        )
        trusted_pub_keys = " ".join(
            [
                item["pubKey"]
                for item in cache
                if "url" in item and "pubKey" in item and item["pubKey"]
            ]
        )
    return [
        *[f"{__NIX__}/bin/nix-build"],
        *["--argstr", "makesSrc", __MAKES_SRC__],
        *["--argstr", "projectSrc", head],
        *["--argstr", "attrPaths", attr_paths],
        *["--attr", attr],
        *["--fallback"],
        *["--option", "experimental-features", "flakes nix-command"],
        *["--option", "cores", "0"],
        *["--option", "narinfo-cache-negative-ttl", "1"],
        *["--option", "narinfo-cache-positive-ttl", "1"],
        *["--option", "max-jobs", "auto"],
        *["--option", "substituters", substituters],
        *["--option", "trusted-public-keys", trusted_pub_keys],
        *_if(out, "--out-link", out),
        *_if(not out, "--no-out-link"),
        *["--show-trace"],
        *[f"{__MAKES_SRC__}/src/evaluator/default.nix"],
    ]


def _nix_hashes(paths: bytes) -> List[str]:
    cmd = [
        "xargs",
        f"{__NIX__}/bin/nix-store",
        "--option", "experimental-features", "flakes nix-command",
        "--query",
        "--hash",
    ]
    out, stdout, _ = _run_outputs(cmd, stdin=paths, stderr=None)
    if out != 0:
        raise SystemExit(out)

    return stdout.decode().splitlines()


def _nix_build_requisites(path: str) -> List[Tuple[str, str]]:
    """Answer the question: what do I need to build `out`."""
    cmd = [f"{__NIX__}/bin/nix-store",
           "--option", "experimental-features", "flakes nix-command",
           "--query",
           "--deriver",
           path]
    out, stdout, _ = _run_outputs(cmd, stderr=None)
    if out != 0:
        raise SystemExit(out)

    cmd = [
        f"{__NIX__}/bin/nix-store",
        "--option", "experimental-features", "flakes nix-command",
        "--query",
        "--requisites",
        "--include-outputs",
        *stdout.decode().splitlines(),
    ]
    out, stdout, _ = _run_outputs(cmd, stderr=None)
    if out != 0:
        raise SystemExit(out)

    requisites: List[str] = stdout.decode().splitlines()

    hashes: List[str] = _nix_hashes(stdout)

    return list(zip(requisites, hashes))


def _get_head(src: str) -> str:
    # Checkout repository HEAD into a temporary directory
    # This is nice for reproducibility and security,
    # files not in the HEAD commit are left out of the build inputs
    CON.out()
    CON.rule(f"Fetching {src}")
    CON.out()
    head: str = _clone_src(src)

    # Applies only to local repositories
    if abspath(src) == CWD:  # `m .` ?
        paths: Set[str] = set()

        # Propagated `git add`ed files
        cmd = ["git", "-C", src, "diff", "--cached", "--name-only"]
        out, stdout, _ = _run_outputs(cmd, stderr=None)
        if out != 0:
            raise SystemExit(out)
        paths.update(stdout.decode().splitlines())

        # Propagated modified files
        cmd = ["git", "-C", src, "ls-files", "--modified"]
        out, stdout, _ = _run_outputs(cmd, stderr=None)
        if out != 0:
            raise SystemExit(out)
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

    return head


class Config(NamedTuple):
    attrs: List[str]
    cache: List[Dict[str, str]]


def _get_named_temporary_file_name() -> str:
    file_name = ""
    with tempfile.NamedTemporaryFile(delete=True) as file:
        file_name = file.name
    return file_name


def _get_config(head: str, attr_paths: str) -> Config:
    CON.out()
    CON.rule("Building project configuration")
    CON.out()

    out: str = _get_named_temporary_file_name()
    code = _run(
        args=_nix_build(
            attr="config.configAsJson",
            attr_paths=attr_paths,
            cache=None,
            head=head,
            out=out,
        ),
        env=None,
        stderr=None,
        stdout=sys.stderr.fileno(),
    )

    if code == 0:
        with open(out, encoding="utf-8") as file:
            config: Dict[str, Any] = json.load(file)

            return Config(attrs=config["outputs"], cache=config["cache"])

    raise SystemExit(code)


def _run_outputs(  # pylint: disable=too-many-arguments
    args: List[str],
    cwd: Optional[str] = None,
    env: Optional[Dict[str, str]] = None,
    stdout: Optional[int] = subprocess.PIPE,
    stderr: Optional[int] = subprocess.PIPE,
    stdin: Optional[bytes] = None,
) -> Tuple[int, bytes, bytes]:
    env = environ | (env or {})

    with subprocess.Popen(
        args=args,
        cwd=cwd,
        env=env,
        shell=False,  # nosec
        stdin=None if stdin is None else subprocess.PIPE,
        stdout=stdout,
        stderr=stderr,
    ) as process:
        try:
            out, err = process.communicate(stdin)
            process.wait()
            return process.returncode, out, err
        except KeyboardInterrupt:
            process.terminate()
            process.wait()
            return 130, bytes(), bytes()


def _run(  # pylint: disable=too-many-arguments
    args: List[str],
    cwd: Optional[str] = None,
    env: Optional[Dict[str, str]] = None,
    stdout: Optional[int] = None,
    stderr: Optional[int] = None,
    stdin: Optional[bytes] = None,
) -> int:
    env = environ | (env or {})

    with subprocess.Popen(
        args=args,
        cwd=cwd,
        env=env,
        shell=False,  # nosec
        stdin=None if stdin is None else subprocess.PIPE,
        stdout=stdout,
        stderr=stderr,
    ) as process:
        try:
            return process.wait()
        except KeyboardInterrupt:
            process.terminate()
            process.wait()
            return 130


def _help_and_exit_base() -> None:
    CON.out()
    CON.rule("Usage")
    CON.out()

    text = "$ m SOURCE"
    CON.print(rich.panel.Panel.fit(text), justify="center")
    CON.out()

    text = """
        Can be:

        A git repository in the current working directory:
            $ m .

        A git repository and revision:
            $ m local:/path/to/repo@rev

        A GitHub repository and revision:
            $ m github:owner/repo@rev

        A GitLab repository and revision:
            $ m gitlab:owner/repo@rev

        Note: A revision is either a branch, full commit or tag
    """
    CON.print(rich.panel.Panel(textwrap.dedent(text), title="SOURCE"))
    CON.out()

    raise SystemExit(1)


def _help_and_exit_with_src_no_tty(src: str, attrs: List[str]) -> None:
    CON.out()
    CON.rule("Usage")
    CON.out()

    text = f"$ m {src} OUTPUT [ARGS...]"
    CON.print(rich.panel.Panel.fit(text), justify="center")
    CON.out()

    text = "Can be:\n\n"
    for attr in attrs:
        if attr not in {
            "__all__",
            "/secretsForAwsFromEnv/__default__",
        }:
            text += f"    {attr}\n"
    CON.print(rich.panel.Panel(text, title="OUTPUT"))
    CON.out()

    text = "Zero or more arguments to pass to the output (if supported)."
    CON.print(rich.panel.Panel(text, title="ARGS"))

    raise SystemExit(1)


def _help_picking_attr(src: str, attrs: List[str]) -> List[str]:
    cache = join(MAKES_DIR, "last.json")
    initial_input = "/"
    if exists(cache):
        with open(cache, encoding="utf-8") as file:
            initial_input = file.read()

    state: Dict[str, Any] = {}
    TextUserInterface.run(
        attrs=attrs, initial_input=initial_input, state=state, src=src
    )

    if "return" in state:
        with open(cache, encoding="utf-8", mode="w") as file:
            file.write(shlex.join(state["return"]))
        return state["return"]

    CON.print()
    CON.print("No command was typed during the prompt", justify="center")
    CON.print()
    CON.print("Please see the correct usage below", justify="center")
    _help_and_exit_with_src_no_tty(src, attrs)
    return []


def cli(args: List[str]) -> None:
    CON.out()
    CON.print(":unicorn_face: [b]Makes[/b]", justify="center")
    CON.print(f"v{VERSION}-{sys.platform}", justify="center")
    if args[1:]:
        src: str = args[1]
    else:
        _help_and_exit_base()

    head: str = _get_head(src)
    attr_paths: str = _get_attr_paths(head)
    config: Config = _get_config(head, attr_paths)

    args, attr = _cli_get_args_and_attr(args, config.attrs, src)

    out: str = join(MAKES_DIR, f"out{attr.replace('/', '-')}")
    provenance: str = join(
        MAKES_DIR,
        f"provenance{attr.replace('/', '-')}.json",
    )
    code = _cli_build(attr, attr_paths, config, head, out, src)

    if code == 0:
        write_provenance(args, head, out, provenance, src)
        cache_push(config.cache, out)
        execute_action(args[3:], head, out)

    raise SystemExit(code)


def _cli_get_args_and_attr(
    args: List[str],
    attrs: List[str],
    src: str,
) -> Tuple[List[str], str]:
    if args[2:]:
        attr: str = args[2]
    elif CON.is_terminal:
        args = [*args[0:2], *_help_picking_attr(src, attrs)]
        attr = args[2]
    else:
        _help_and_exit_with_src_no_tty(src, attrs)

    return args, attr


def _cli_build(  # pylint: disable=too-many-arguments
    attr: str,
    attr_paths: str,
    config: Config,
    head: str,
    out: str,
    src: str,
) -> int:
    CON.out()
    CON.rule(f"Building {attr}")
    CON.out()
    if attr not in config.attrs:
        CON.print(f"We can't proceed with OUTPUT: {attr}", justify="center")
        CON.print("It is not a valid project output", justify="center")
        CON.print()
        CON.print("Please see the correct usage below", justify="center")
        _help_and_exit_with_src_no_tty(src, config.attrs)

    code = _run(
        args=_nix_build(
            attr=f'config.outputs."{attr}"',
            attr_paths=attr_paths,
            cache=config.cache,
            head=head,
            out=out,
        ),
        env=None,
        stderr=None,
        stdout=None,
    )

    return code


def execute_action(args: List[str], head: str, out: str) -> None:
    action_path: str = join(out, "makes-action.sh")

    if exists(action_path):
        CON.out()
        CON.rule("Running")
        CON.out()
        code = _run(
            args=[action_path, out, *args],
            stderr=None,
            stdout=None,
            cwd=head if AWS_BATCH_COMPAT else CWD,
        )
        raise SystemExit(code)


def cache_push(cache: List[Dict[str, str]], out: str) -> None:
    once = True
    for config in [item for item in cache if item.get("token", "") in environ]:
        if once:
            CON.rule("Pushing to cache")
            once = False
        if config["type"] in "cachix":
            _run(
                args=["cachix", "authtoken", environ[config["token"]]],
                stderr=None,
                stdout=sys.stderr.fileno(),
            )
            _run(
                args=["cachix", "push", config["name"], out],
                stderr=None,
                stdout=sys.stderr.fileno(),
            )


def _get_sys_id() -> str:
    with suppress(AttributeError):
        uname = os.uname()
        return f"{uname.nodename}-{uname.sysname}-{uname.machine}"

    with suppress(OSError):
        return gethostname()

    return "unknown"


def _get_usr() -> str:
    with suppress(OSError):
        return getlogin()

    return "unknown"


def write_provenance(
    args: List[str],
    head: str,
    out: str,
    provenance: str,
    src: str,
) -> None:
    src_uri: str = (
        # GitLab
        (
            f"git+{environ['CI_PROJECT_URL']}"
            if "CI_PROJECT_URL" in environ
            else ""
        )
        # GitHub
        or (
            f"git+https://{environ['GITHUB_SERVER_URL']}"
            f"/{environ['GITHUB_REPOSITORY']}"
            if "GITHUB_SERVER_URL" in environ
            and "GITHUB_REPOSITORY" in environ
            else ""
        )
        # Local
        or (f"git+file://{abspath(src)}" if abspath(src) == CWD else "")
        # Other
        or src
    )

    CON.rule("Provenance")
    attestation: Dict[str, Any] = {}
    attestation["_type"] = "https://in-toto.io/Statement/v0.1"
    attestation["predicateType"] = "https://slsa.dev/provenance/v0.2"

    attestation["predicate"] = {}
    attestation["predicate"]["builder"] = {}
    attestation["predicate"]["builder"]["id"] = f"{_get_usr()}@{_get_sys_id()}"
    attestation["predicate"]["buildType"] = (
        f"https://fluidattacks.com/Attestations/Makes@{VERSION}",
    )
    attestation["predicate"]["invocation"] = {}
    attestation["predicate"]["invocation"]["configSource"] = {
        "uri": src_uri,
        "digest": {"sha1": _clone_src_git_rev_parse(head, "HEAD")},
        "entrypoint": args[2],
    }
    attestation["predicate"]["invocation"]["parameters"] = args[3:]
    attestation["predicate"]["invocation"]["environment"] = {
        key: "" for key in environ
    }
    attestation["predicate"]["metadata"] = {}
    attestation["predicate"]["metadata"]["completeness"] = {}
    attestation["predicate"]["metadata"]["completeness"]["environment"] = True
    attestation["predicate"]["metadata"]["completeness"]["materials"] = True
    attestation["predicate"]["metadata"]["completeness"]["parameters"] = True
    attestation["predicate"]["metadata"]["reproducible"] = True
    attestation["predicate"]["materials"] = [
        {
            "uri": requisite,
            "hash": dict([hash_.split(":")]),
        }
        for requisite, hash_ in _nix_build_requisites(out)
    ]

    attestation["subject"] = [
        {
            "uri": realpath(out),
            "hash": dict([_nix_hashes(out.encode())[0].split(":")]),
        }
    ]

    attestation_bytes = json.dumps(
        attestation,
        indent=2,
        sort_keys=True,
    ).encode()

    with open(provenance, mode="wb+") as attestation_file:
        attestation_file.write(attestation_bytes)

    integrity = sha256(attestation_bytes).hexdigest()

    CON.out(f"Attestation: {provenance}")
    CON.out(f"SHA-256: {integrity}")


def main(args: List[str]) -> None:
    try:
        try:
            cli(args)
        except SystemExit as err:
            CON.out()
            if err.code == 0:
                emo = random.choice(emojis.SUCCESS)  # nosec
                CON.rule(f":{emo}: Success!")
            else:
                emo = random.choice(emojis.FAILURE)  # nosec
                CON.rule(
                    f":{emo}: Failed with exit code {err.code}", style="red"
                )
            CON.out()
            sys.exit(err.code)
    finally:
        cleanup()


def cleanup() -> None:
    for action in ON_EXIT:
        with suppress(BaseException):
            action()
