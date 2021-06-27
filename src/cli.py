import click
import os
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
def cli(
    attr: str,
    debug: bool,
) -> None:
    with subprocess.Popen(
        args=[
            os.environ["_NIX_BUILD"],
            "--arg",
            "head",
            "./.",
            "--attr",
            f"config.outputs{attr}",
            *_if(debug, "--show-trace"),
            os.environ["_EVALUATOR"],
        ],
    ) as _:
        pass


if __name__ == "__main__":
    cli(prog_name="makes")  # noqa
