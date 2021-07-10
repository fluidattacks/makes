import json
import os
from os import (
    environ,
    getcwd,
)
from os.path import (
    exists,
    join,
)
import shutil
import subprocess
import sys
import tempfile
from typing import (
    Any,
    Dict,
    List,
    Optional,
    Set,
    Tuple,
)

DEBUG: bool = "M_DEBUG" in environ
FROM_LOCAL = f"file://{getcwd()}"
FROM: str = environ.get("M_FROM", FROM_LOCAL)
VERSION: str = environ["_M_VERSION"]


class Error(Exception):
    pass


def _log(*args: str) -> None:
    print(*args, file=sys.stderr)


def _if(condition: Any, *value: Any) -> List[Any]:
    return list(value) if condition else []


def _nix_build(head: str, attr: str, out: str = "") -> List[str]:
    head = f'builtins.path {{ name = "head"; path = {head}; }}'
    return [
        environ["_NIX_BUILD"],
        *["--arg", "head", head],
        *["--argstr", "makesVersion", VERSION],
        *["--attr", attr],
        *["--option", "narinfo-cache-negative-ttl", "1"],
        *["--option", "narinfo-cache-positive-ttl", "1"],
        *["--option", "restrict-eval", "false"],
        *["--option", "sandbox", "false"],
        *_if(out, "--out-link", out),
        *_if(not out, "--no-out-link"),
        *_if(DEBUG, "--show-trace"),
        environ["_EVALUATOR"],
    ]


def _get_head() -> str:
    # Checkout repository HEAD into a temporary directory
    # This is nice for reproducibility and security,
    # files not in the HEAD commit are left out of the build inputs
    head = tempfile.TemporaryDirectory(prefix="makes-").name
    out, stdout, stderr = _run(
        args=["git", "clone", "--depth", "1", FROM, head],
    )
    if out != 0:
        raise Error(f"Unable to clone: {FROM}", stdout, stderr)

    # Applies only to local repositories
    if FROM == FROM_LOCAL:
        paths: Set[str] = set()

        # Propagated `git add`ed files
        out, stdout, stderr = _run(["git", "diff", "--cached", "--name-only"])
        if out != 0:
            raise Error(f"Unable to list files: {FROM}", stdout, stderr)
        paths.update(stdout.decode().splitlines())

        # Propagated modified files
        out, stdout, stderr = _run(["git", "ls-files", "--modified"])
        if out != 0:
            raise Error(f"Unable to list files: {FROM}", stdout, stderr)
        paths.update(stdout.decode().splitlines())

        # Copy paths to head
        for path in sorted(paths):
            shutil.copy(path, os.path.join(head, path))

    shutil.rmtree(os.path.join(head, ".git"))
    return head


def _get_attrs(head: str) -> List[str]:
    out: str = tempfile.mktemp()
    code, stdout, stderr, = _run(
        args=_nix_build(head, "config.attrs", out),
    )
    if code == 0:
        with open(out) as file:
            return json.load(file)

    raise Error(f"Unable to list project outputs from: {FROM}", stdout, stderr)


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
    attrs: Optional[List[str]] = None,
    exc: Optional[Exception] = None,
) -> None:
    _log("Usage: m [OUTPUT] [ARGS]...")
    if attrs is not None:
        _log()
        _log(f"Outputs list for project: {FROM}")
        for attr in attrs:
            if attr not in {"__all__"}:
                _log(f"  {attr}")
    if exc is not None:
        _log()
        raise exc

    raise SystemExit(1)


def cli(args: List[str]) -> None:
    _log(f"Makes v{VERSION}")
    _log()
    if not args[1:]:
        try:
            head: str = _get_head()
            attrs: List[str] = _get_attrs(head)
        except Error as exc:
            _help_and_exit(exc=exc)
        else:
            _help_and_exit(attrs)

    attr: str = args[1]
    args = args[2:]
    head = _get_head()
    attrs = _get_attrs(head)
    if attr not in attrs:
        _help_and_exit(attrs)

    cwd: str = getcwd()
    out: str = join(cwd, f"result{attr.replace('/', '-')}")
    actions_path: str = join(out, "makes-actions.json")

    code, _, _ = _run(
        args=_nix_build(head, f'config.outputs."{attr}"', out),
        capture_io=False,
    )

    if code == 0:
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

    raise SystemExit(code)


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


if __name__ == "__main__":
    main()
