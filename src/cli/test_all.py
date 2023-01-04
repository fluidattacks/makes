from main import (
    cli,
    emojis,
    tui,
)
import os
import pytest
import shutil


def test_imports() -> None:
    assert emojis
    assert tui


def test_tui() -> None:
    assert tui.TuiCommand(src=".").render()
    assert tui.TuiUsage(src=".").render()
    assert tui.TuiHeader().render()
    tui_outputs = tui.TuiOutputs()
    tui_outputs.outputs = ["/a", "/b"]
    assert tui_outputs.render()
    assert tui.TuiOutputsTitle().render()


def test_help() -> None:
    with pytest.raises(SystemExit) as result:
        cli.main(["m"])
    assert result.value.code == 1

    with pytest.raises(SystemExit) as result:
        cli.main(["m", "--help"])
    assert result.value.code == 1


def test_dot_wrong() -> None:
    with pytest.raises(SystemExit) as result:
        cli.main(["m", ".", "/shouldn't/exist"])
    assert result.value.code == 1


def test_dot_hello_world() -> None:
    with pytest.raises(SystemExit) as result:
        cli.main(["m", ".", "/helloWorld"])
    assert result.value.code == 0


def test_remote_hello_world() -> None:
    cache = (
        os.environ["HOME_IMPURE"]
        + "/.makes/cache/sources/github-fluidattacks-makes-main"
    )

    shutil.rmtree(cache, ignore_errors=True)

    with pytest.raises(SystemExit) as result:
        cli.main(["m", "github:fluidattacks/makes@main", "/helloWorld"])
    assert result.value.code == 0

    with pytest.raises(SystemExit) as result:
        cli.main(["m", "github:fluidattacks/makes@main", "/helloWorld"])
    assert result.value.code == 0

    with pytest.raises(SystemExit) as result:
        cli.main(["m", f"local:{cache}@main", "/helloWorld"])
    assert result.value.code == 0

    with pytest.raises(SystemExit) as result:
        cli.main(["m", f"local:{cache}@shouldn't-exist", "/helloWorld"])
    assert result.value.code == 128

    with pytest.raises(SystemExit) as result:
        cli.main(["m", "gitlab:fluidattacks/shouldn't@exist", "/helloWorld"])
    assert result.value.code == 128
