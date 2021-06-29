import json
from os import (
    environ,
    getcwd,
)
from os.path import (
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
FROM: str = environ.get("MAKES_FROM", "./")
VERSION: str = "4.0"


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


def _get_head() -> str:
    if FROM == "./":
        return "./."

    raise NotImplementedError()


def _get_attrs(head: str) -> List[str]:
    out: str = tempfile.mktemp()
    process: subprocess.CompletedProcess = subprocess.run(
        args=_nix_build(head, "config.attrs", out),
        check=False,
    )
    if process.returncode == 0:
        with open(out) as file:
            return [f".{attr}" for attr in json.load(file)]

    sys.exit(1)


def _help_and_exit(attrs: Optional[List[str]] = None) -> None:
    print("Usage: makes [OUTPUT] [ARGS]...")
    print()
    print("A SecDevOps Framework powered by Nix.")
    if attrs is not None:
        print()
        print(f"Outputs list for project: {FROM}")
        for attr in attrs:
            print(f"  {attr}")
    sys.exit(1)


def cli(args: List[str]) -> None:
    if not args[1:]:
        _help_and_exit()

    attr: str = args[1]
    args = args[2:]
    head: str = _get_head()
    attrs: List[str] = _get_attrs(head)
    if attr not in attrs:
        _help_and_exit(attrs)

    cwd: str = getcwd()
    out: str = join(cwd, f"result{attr.replace('.', '-')}")
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
    cli(sys.argv)
