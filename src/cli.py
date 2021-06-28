import click
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
from typing import (
    List,
)

VERSION: str = "4.0"


def _if(condition: bool, value: str) -> List[str]:
    return [value] if condition else []


@click.command(help="A SecDevOps Framework powered by Nix.")
@click.option("--debug", is_flag=True)
@click.argument("attr")
@click.argument("args", nargs=-1)
def cli(
    attr: str,
    args: List[str],
    debug: bool,
) -> None:
    cwd: str = getcwd()
    out: str = join(cwd, f"result{attr.replace('.', '-')}")
    actions_path: str = join(out, "makes-actions.json")

    process: subprocess.CompletedProcess = subprocess.run(
        args=[
            environ["_NIX_BUILD"],
            "--arg",
            "head",
            "./.",
            "--attr",
            f'config.outputs."{attr}"',
            "--out-link",
            out,
            *_if(debug, "--show-trace"),
            environ["_EVALUATOR"],
        ],
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
    cli(prog_name="makes")  # noqa
