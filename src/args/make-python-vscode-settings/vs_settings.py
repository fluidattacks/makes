from json import (
    dump,
    load,
)
from pathlib import (
    Path,
)
import sys
from typing import (
    Tuple,
)


def set_settings(settings_path: Path, python_env: Path) -> None:
    settings_path.touch(exist_ok=True)
    env_settings = {
        "python.pythonPath": (python_env / "bin/python").as_posix(),
        "python.defaultInterpreterPath": (
            python_env / "bin/python"
        ).as_posix(),
        "mypy.dmypyExecutable": (python_env / "bin/dmypy").as_posix(),
        "python.linting.pylintPath": (python_env / "bin/pylint").as_posix(),
        "python.testing.pytestArgs": ["tests"],
        "python.testing.unittestEnabled": False,
        "python.testing.pytestEnabled": True,
        "python.linting.enabled": True,
        "python.linting.mypyEnabled": False,
        "python.linting.pylintEnabled": True,
    }
    with open(settings_path, "r+", encoding="UTF-8") as file:
        if file.read() == "":
            settings = {}
        else:
            file.seek(0)
            settings = load(file)  # type: ignore[misc]
    with open(settings_path, "w+", encoding="UTF-8") as file:
        new_settings = settings | env_settings
        dump(new_settings, file, indent=2)


def main(args: Tuple[str, ...]) -> None:
    settings = Path(args[1])
    env = Path(args[2])
    if env.exists():
        set_settings(settings, env)
    else:
        raise Exception(f"Non existent env: {env}")


if __name__ == "__main__":
    main(tuple(sys.argv))
