import json
from os import (
    environ,
    getcwd,
)
from os.path import (
    abspath,
    exists,
    join,
)
import subprocess
import sys
import tempfile
from typing import (
    Any,
    List,
    Optional,
)

DEBUG: bool = "MAKES_DEBUG" in environ
FROM: str = environ.get("MAKES_FROM", f"file://{getcwd()}")
VERSION: str = "4.0"


class Error(Exception):
    pass


def _log(*args: str) -> None:
    print(*args, file=sys.stderr)


def _if(condition: Any, value: str) -> List[str]:
    return [value] if condition else []


def _nix_build(head: str, attr: str, out: str = "") -> List[str]:
    return [
        environ["_NIX_BUILD"],
        "--arg",
        "head",
        head,
        "--attr",
        attr,
        *_if(out, "--out-link"),
        *_if(out, out),
        *_if(not out, "--no-out-link"),
        *_if(DEBUG, "--show-trace"),
        environ["_EVALUATOR"],
    ]


def _get_head_from_file() -> str:
    return abspath(FROM[7:])


def _get_head() -> str:
    if FROM.startswith("file://"):
        return _get_head_from_file()

    raise Error(f"Unable to load Makes project from: {FROM}")


def _get_attrs(head: str) -> List[str]:
    out: str = tempfile.mktemp()
    process: subprocess.CompletedProcess = subprocess.run(
        args=_nix_build(head, "config.attrs", out),
        check=False,
    )
    if process.returncode == 0:
        with open(out) as file:
            return [f".{attr}" for attr in json.load(file)]

    raise Error(f"Unable to list project outputs from: {FROM}")


def _help_and_exit(attrs: Optional[List[str]] = None) -> None:
    _log("Usage: makes [OUTPUT] [ARGS]...")
    _log()
    _log("A SecDevOps Framework powered by Nix.")
    if attrs is not None:
        _log()
        _log(f"Outputs list for project: {FROM}")
        for attr in attrs:
            _log(f"  {attr}")
    sys.exit(1)


def cli(args: List[str]) -> None:
    if not args[1:]:
        try:
            head: str = _get_head()
            attrs: List[str] = _get_attrs(head)
        except Error:
            _help_and_exit()
        else:
            _help_and_exit(attrs)

    attr: str = args[1]
    args = args[2:]
    head = _get_head()
    attrs = _get_attrs(head)
    if attr not in attrs:
        _help_and_exit(attrs)

    cwd: str = getcwd()
    out: str = join(cwd, f"result{attr}")
    actions_path: str = join(out, "makes-actions.json")

    process: subprocess.CompletedProcess = subprocess.run(
        args=_nix_build(head, f"config.outputs{attr}", out),
        check=False,
    )

    if process.returncode == 0:
        if exists(actions_path):
            with open(actions_path) as actions_file:
                for action in json.load(actions_file):
                    if action["type"] == "exec":
                        subprocess.run(
                            args=[join(out, action["location"][1:]), *args],
                            check=False,
                        )


if __name__ == "__main__":
    try:
        cli(sys.argv)
    except Error as err:
        _log(f"[ERROR] {err}")
        sys.exit(1)
