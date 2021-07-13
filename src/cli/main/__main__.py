from contextlib import (
    suppress,
)
from functools import (
    partial,
)
import json
from os import (
    environ,
    getcwd,
    makedirs,
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
import subprocess
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

CWD: str = getcwd()
ON_EXIT: List[Callable[[], None]] = []
VERSION: str = "21.08"


class Error(Exception):
    pass


def _log(*args: str) -> None:
    print(*args, file=sys.stderr)


def _if(condition: Any, *value: Any) -> List[Any]:
    return list(value) if condition else []


def _clone_src(src: str) -> str:
    args: List[str]
    head = tempfile.TemporaryDirectory(prefix="makes-").name
    ON_EXIT.append(partial(shutil.rmtree, head, ignore_errors=True))

    if is_src_local(src):
        args = [abspath(src)]

    elif match := re.match(
        r"^github:(?P<owner>.*)/(?P<repo>.*)@(?P<rev>.*)$", src
    ):
        owner = url_quote(match.group("owner"))
        repo = url_quote(match.group("repo"))
        rev = url_quote(match.group("rev"))
        args = [f"https://github.com/{owner}/{repo}", "--branch", rev]

    elif match := re.match(
        r"^gitlab:(?P<owner>.*)/(?P<repo>.*)@(?P<rev>.*)$", src
    ):
        owner = url_quote(match.group("owner"))
        repo = url_quote(match.group("repo"))
        rev = url_quote(match.group("rev"))
        args = [f"https://gitlab.com/{owner}/{repo}", "--branch", rev]

    else:
        raise Error(f"Unable to parse [SOURCE]: {src}")

    out, stdout, stderr = _run(["git", "clone", "--depth", "1", *args, head])
    if out != 0:
        raise Error(f"Unable to clone: {src}", stdout, stderr)

    return head


def is_src_local(src: str) -> bool:
    return isdir(src)


def _nix_build(src: str, head: str, attr: str, out: str = "") -> List[str]:
    head = f'builtins.path {{ name = "head"; path = {head}; }}'
    return [
        "nix-build",
        *_if(is_src_local(src), "--argstr", "headImpure", src),
        *["--arg", "head", head],
        *["--argstr", "makesVersion", VERSION],
        *["--attr", attr],
        *["--option", "narinfo-cache-negative-ttl", "1"],
        *["--option", "narinfo-cache-positive-ttl", "1"],
        *["--option", "restrict-eval", "false"],
        *["--option", "sandbox", "false"],
        *_if(out, "--out-link", out),
        *_if(not out, "--no-out-link"),
        *["--show-trace"],
        environ["_EVALUATOR"],
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
            if not exists(dirname(dest)):
                makedirs(dirname(dest))
            if exists(path):
                shutil.copy(join(src, path), dest)

    shutil.rmtree(join(head, ".git"))
    return head


def _get_attrs(src: str, head: str) -> List[str]:
    out: str = tempfile.mktemp()
    code, stdout, stderr, = _run(
        args=_nix_build(src, head, "config.attrs", out),
    )
    if code == 0:
        with open(out) as file:
            return json.load(file)

    raise Error(f"Unable to list project outputs from: {src}", stdout, stderr)


def _run(
    args: List[str],
    cwd: Optional[str] = None,
    env: Optional[Dict[str, str]] = None,
    capture_io: bool = True,
) -> Tuple[int, bytes, bytes]:
    with subprocess.Popen(
        args=args,
        cwd=cwd,
        env=env,
        stdout=subprocess.PIPE if capture_io else None,
        stderr=subprocess.PIPE if capture_io else None,
    ) as process:
        out, err = bytes(), bytes()
        if capture_io:
            out, err = process.communicate()

        process.wait()

        return process.returncode, out, err


def _help_and_exit(
    src: Optional[str] = None,
    attrs: Optional[List[str]] = None,
    exc: Optional[Exception] = None,
) -> None:
    _log("Usage: m [SOURCE] [OUTPUT] [ARGS]...")
    if not src:
        _log()
        _log("[SOURCE] can be:")
        _log()
        _log("  A local Git repository:")
        _log("    /path/to/local/repository")
        _log("    ./relative/path")
        _log("    .")
        _log()
        _log("  A GitHub repository, rev (branch or tag):")
        _log("    github:owner/repo@rev")
        _log()
        _log("  A GitLab repository, rev (branch or tag):")
        _log("    gitlab:owner/repo@rev")
    if attrs is not None:
        _log()
        _log("[OUTPUT] can be:")
        for attr in attrs:
            if attr not in {"__all__"}:
                _log(f"  {attr}")
    if exc is not None:
        _log()
        raise exc

    _log()
    _log("[ARGS] are passed to the output (if supported).")

    raise SystemExit(1)


def cli(args: List[str]) -> None:
    _log(f"Makes v{VERSION}")
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

    out: str = join(CWD, f"result{attr.replace('/', '-')}")

    code, _, _ = _run(
        args=_nix_build(src, head, f'config.outputs."{attr}"', out),
        capture_io=False,
    )

    if code == 0:
        execute_actions(args, out)

    raise SystemExit(code)


def execute_actions(args: List[str], out: str) -> None:
    actions_path: str = join(out, "makes-actions.json")

    if exists(actions_path):
        with open(actions_path) as actions_file:
            for action in json.load(actions_file):
                if action["type"] == "exec":
                    action_target: str = join(out, action["location"][1:])
                    code, _, _ = _run(
                        args=[action_target, *args],
                        capture_io=False,
                    )
                    raise SystemExit(code)
                if action["type"] == "cat":
                    _log()
                    action_target = join(out, action["location"][1:])
                    with open(action_target) as file:
                        print(file.read())
                    raise SystemExit(0)


def main() -> None:
    try:
        cli(sys.argv)
    except Error as err:
        _log(f"[ERROR] {err.args[0]}")
        if err.args[1:]:
            _log(f"[ERROR] Stdout: {err.args[1].decode(errors='replace')}")
        if err.args[2:]:
            _log(f"[ERROR] Stderr: {err.args[2].decode(errors='replace')}")
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
