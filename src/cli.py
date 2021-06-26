import click
import os
import subprocess

VERSION: str = "4.0"


@click.command(help="A SecDevOps Framework powered by Nix.")
@click.argument("attr")
def cli(attr: str) -> None:
    with subprocess.Popen(
        args=[
            os.environ["_NIX_INSTANTIATE"],
            "--eval",
            "--arg",
            "head",
            "./.",
            "--strict",
            "-A",
            f"makes.module.config.{attr}",
        ],
    ) as _:
        pass


if __name__ == "__main__":
    cli(prog_name=f"Makes v{VERSION}")  # noqa
