from contextlib import (
    suppress,
)
from functools import (
    partial,
)
import io
import json
import operator
from os import (
    environ,
    getcwd,
    makedirs,
    remove,
)
from os.path import (
    commonprefix,
    exists,
    getctime,
    join,
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
import subprocess  # nosec
import sys
import tempfile
import textual.app
import textual.events
import textual.keys
import textual.reactive
import textual.widget
import textual.widgets
import textwrap
from time import (
    time,
)
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
import warnings

CWD: str = getcwd()
CON: rich.console.Console = rich.console.Console(
    highlight=False,
    file=io.TextIOWrapper(sys.stderr.buffer, write_through=True),
)
MAKES_DIR: str = join(environ["HOME_IMPURE"], ".makes")
makedirs(join(MAKES_DIR, "cache"), exist_ok=True)
SOURCES_CACHE: str = join(MAKES_DIR, "cache", "sources")
ON_EXIT: List[Callable[[], None]] = []
VERSION: str = "22.07"

# Environment
__MAKES_REGISTRY__: str = environ["__MAKES_REGISTRY__"]
__MAKES_SRC__: str = environ["__MAKES_SRC__"]
__NIX_STABLE__: str = environ["__NIX_STABLE__"]
__NIX_UNSTABLE__: str = environ["__NIX_UNSTABLE__"]


# Feature flags
AWS_BATCH_COMPAT: bool = bool(environ.get("MAKES_AWS_BATCH_COMPAT"))
if AWS_BATCH_COMPAT:
    CON.out("Using feature flag: MAKES_AWS_BATCH_COMPAT")
    CON.out()

GIT_DEPTH: int = int(environ.get("MAKES_GIT_DEPTH", "1"))
if GIT_DEPTH != 1:
    CON.out(f"Using feature flag: MAKES_GIT_DEPTH={GIT_DEPTH}")


K8S_COMPAT: bool = bool(environ.get("MAKES_K8S_COMPAT"))
if K8S_COMPAT:
    CON.out("Using feature flag: MAKES_K8S_COMPAT")

NIX_STABLE: bool = not bool(environ.get("MAKES_NIX_UNSTABLE"))
if not NIX_STABLE:
    CON.out("Using feature flag: MAKES_NIX_UNSTABLE")


# Constants
EMOJIS_FAILURE = [
    "alien_monster",  # 👾
    "anxious_face_with_sweat",  # 😰
    "beetle",  # 🐞
    "blowfish",  # 🐡
    "brick",  # 🧱
    "broken_heart",  # 💔
    "bug",  # 🐛
    "collision",  # 💥
    "dizzy_face",  # 😵
    "exploding_head",  # 🤯
    "eyes",  # 👀
    "face_with_monocle",  # 🧐
    "fire",  # 🔥
    "ghost",  # 👻
    "lady_beetle",  # 🐞
    "mega",  # 📣
    "microscope",  # 🔬
    "moai",  # 🗿
    "open_mouth",  # 😮
    "person_facepalming",  # 🤦
    "person_getting_massage",  # 💆
    "sad_but_relieved_face",  # 😥
    "see_no_evil",  # 🙈
    "smiling_imp",  # 😈
    "speak_no_evil",  # 🙊
    "thinking_face",  # 🤔
    "upside__down_face",  # 🙃
    "volcano",  # 🌋
    "wilted_flower",  # 🥀
    "woozy_face",  # 🥴
    "yawning_face",  # 🥱
    "zipper__mouth_face",  # 🤐
]
EMOJIS_SUCCESS = [
    "airplane_departure",  # 🛫
    "beer",  # 🍺
    "beers",  # 🍻
    "birthday",  # 🎂
    "bottle_with_popping_cork",  # 🍾
    "bouquet",  # 💐
    "bulb",  # 💡
    "blossom",  # 🌼
    "boxing_glove",  # 🥊
    "call_me_hand",  # 🤙
    "cat",  # 🐱
    "clapping_hands",  # 👏
    "clinking_glasses",  # 🥂
    "colombia",  # 🇨🇴
    "confetti_ball",  # 🎊
    "couple_with_heart",  # 💑
    "checkered_flag",  # 🏁
    "crown",  # 👑
    "dart",  # 🎯
    "dog",  # 🐶
    "dancer",  # 💃
    "doughnut",  # 🍩
    "eagle",  # 🦅
    "elephant",  # 🐘
    "face_blowing_a_kiss",  # 😘
    "flamingo",  # 🦩
    "four_leaf_clover",  # 🍀
    "fries",  # 🍟
    "glowing_star",  # 🌟
    "kite",  # 🪁
    "mage",  # 🧙
    "merperson",  # 🧜
    "money_with_wings",  # 💸
    "nail_care",  # 💅
    "party_popper",  # 🎉
    "partying_face",  # 🥳
    "person_cartwheeling",  # 🤸
    "person_playing_handball",  # 🤾
    "person_playing_water_polo",  # 🤽
    "person_surfing",  # 🏄
    "pizza",  # 🍕
    "popcorn",  # 🍿
    "rainbow",  # 🌈
    "shooting_star",  # 🌠
    "smiling_face_with_sunglasses",  # 😎
    "smirk",  # 😏
    "rocket",  # 🚀
    "trophy",  # 🏆
    "whale",  # 🐳
    "wink",  # 😉
]


def _if(condition: Any, *value: Any) -> List[Any]:
    return list(value) if condition else []


def _clone_src(src: str) -> str:
    # pylint: disable=consider-using-with
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        head = tempfile.TemporaryDirectory(prefix="makes-").name
    ON_EXIT.append(partial(shutil.rmtree, head, ignore_errors=True))

    if abspath(src) == CWD:  # `m .` ?
        if NIX_STABLE:
            _add_safe_directory()
            _clone_src_git_worktree_add(src, head)
        else:
            # Nix with Flakes already ensures a pristine git repo
            head = src
    else:
        _add_safe_directory()
        src = _clone_src_apply_registry(src)
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


def _add_safe_directory() -> None:
    cmd = [
        "git",
        "config",
        "--global",
        "--add",
        "safe.directory",
        "/github/workspace",
    ]
    out, _, _ = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)


def _clone_src_git_init(head: str) -> None:
    cmd = ["git", "init", "--initial-branch=____", "--shared=false", head]
    out, _, _ = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)


def _clone_src_git_fetch(head: str, remote: str, rev: str) -> None:
    depth = _if(GIT_DEPTH >= 1, f"--depth={GIT_DEPTH}")
    cmd = ["git", "-C", head, "fetch", *depth, remote, f"{rev}:{rev}"]
    out, _, _ = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)


def _clone_src_git_checkout(head: str, rev: str) -> None:
    cmd = ["git", "-C", head, "checkout", rev]
    out, _, _ = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)


def _clone_src_git_worktree_add(remote: str, head: str) -> None:
    cmd = ["git", "-C", remote, "worktree", "add", head, "HEAD"]
    out, _, _ = _run(cmd, stderr=None, stdout=sys.stderr.fileno())
    if out != 0:
        raise SystemExit(out)
    CON.out(head)


def _clone_src_apply_registry(src: str) -> str:
    with open(__MAKES_REGISTRY__, encoding="utf-8") as file:
        registry = json.load(file)

        for to_, from_ in registry.items():
            src = re.sub(from_, to_, src)

    return src


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


def _nix_build(
    *,
    attr: str,
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
        substituters = " ".join(map(operator.itemgetter("url"), cache))
        trusted_pub_keys = " ".join(map(operator.itemgetter("pubKey"), cache))

    return [
        *_if(NIX_STABLE, f"{__NIX_STABLE__}/bin/nix-build"),
        *_if(not NIX_STABLE, f"{__NIX_UNSTABLE__}/bin/nix"),
        *_if(not NIX_STABLE, "--experimental-features", "flakes nix-command"),
        *_if(not NIX_STABLE, "build"),
        *_if(NIX_STABLE, "--argstr", "makesSrc", __MAKES_SRC__),
        *_if(NIX_STABLE, "--argstr", "projectSrc", head),
        *_if(NIX_STABLE, "--attr", attr),
        *["--option", "cores", "0"],
        *_if(not NIX_STABLE, "--impure"),
        *["--option", "narinfo-cache-negative-ttl", "1"],
        *["--option", "narinfo-cache-positive-ttl", "1"],
        *["--option", "max-jobs", "auto"],
        *["--option", "substituters", substituters],
        *["--option", "trusted-public-keys", trusted_pub_keys],
        *["--option", "sandbox", "false" if K8S_COMPAT else "true"],
        *_if(out, "--out-link", out),
        *_if(not out, "--no-out-link"),
        *["--show-trace"],
        *_if(NIX_STABLE, f"{__MAKES_SRC__}/src/evaluator/default.nix"),
        *_if(not NIX_STABLE, attr),
    ]


def _get_head(src: str) -> str:
    # Checkout repository HEAD into a temporary directory
    # This is nice for reproducibility and security,
    # files not in the HEAD commit are left out of the build inputs
    CON.out()
    CON.rule(f"Fetching {src}")
    CON.out()
    head: str = _clone_src(src)

    # Applies only to local repositories on non-flakes Nix
    if abspath(src) == CWD and NIX_STABLE:  # `m .` ?
        paths: Set[str] = set()

        # Propagated `git add`ed files
        cmd = ["git", "-C", src, "diff", "--cached", "--name-only"]
        out, stdout, _ = _run(cmd, stderr=None)
        if out != 0:
            raise SystemExit(out)
        paths.update(stdout.decode().splitlines())

        # Propagated modified files
        cmd = ["git", "-C", src, "ls-files", "--modified"]
        out, stdout, _ = _run(cmd, stderr=None)
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


def _get_config(head: str) -> Dict[str, Any]:
    CON.out()
    CON.rule("Building project configuration")
    CON.out()
    out: str = tempfile.mktemp()  # nosec
    code, _, _, = _run(
        args=_nix_build(
            attr="config.configAsJson"
            if NIX_STABLE
            else f'{head}#__makes__."config:configAsJson"',
            cache=None,
            head=head,
            out=out,
        ),
        env=None if NIX_STABLE else dict(HOME=environ["HOME_IMPURE"]),
        stderr=None,
        stdout=sys.stderr.fileno(),
    )

    if code == 0:
        with open(out, encoding="utf-8") as file:
            return json.load(file)

    raise SystemExit(code)


def _run(  # pylint: disable=too-many-arguments
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
        out, err = process.communicate(stdin)

    return process.returncode, out, err


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


class TuiHeader(textual.widget.Widget):
    def render(self) -> rich.text.Text:
        text = ":unicorn_face: Makes"
        return rich.text.Text.from_markup(text, justify="center")


class TuiUsage(textual.widget.Widget):
    def __init__(self, *args: Any, src: str, **kwargs: Any) -> None:
        self.src = src
        super().__init__(*args, **kwargs)

    def render(self) -> rich.align.Align:
        text = f"$ m {self.src} OUTPUT [ARGS...]"
        panel = rich.panel.Panel.fit(text, title="Usage")
        return rich.align.Align(panel, align="center")


class TuiCommand(textual.widget.Widget):
    input = textual.reactive.Reactive("")

    def __init__(self, *args: Any, src: str, **kwargs: Any) -> None:
        self.src = src
        super().__init__(*args, **kwargs)

    def render(self) -> rich.align.Align:
        panel = rich.panel.Panel.fit(
            renderable=f"$ m {self.src} {self.input}",
            title="Please type the command you want to execute:",
        )
        return rich.align.Align(panel, align="center")


class TuiOutputs(textual.widget.Widget):
    output = textual.reactive.Reactive("")
    outputs = textual.reactive.Reactive([])

    def render(self) -> rich.text.Text:
        if self.outputs:
            longest = max(map(len, self.outputs))
            text = rich.text.Text()
            for output in self.outputs:
                text.append(self.output, style="yellow")
                text.append(output[len(self.output) :])
                text.append(" " * (longest - len(output)))
                text.append("\n")
        else:
            text = rich.text.Text("(none)")
        return rich.align.Align(text, align="center")


class TuiOutputsTitle(textual.widget.Widget):
    output = textual.reactive.Reactive("")

    def render(self) -> rich.text.Text:
        text = rich.text.Text("Outputs starting with: ", justify="center")
        text.append(self.output, style="yellow")
        return text


class TextUserInterface(textual.app.App):
    # pylint: disable=too-many-instance-attributes
    def __init__(
        self,
        *args: Any,
        src: str,
        attrs: List[str],
        initial_input: str,
        state: Dict[str, Any],
        **kwargs: Any,
    ) -> None:
        self.attrs = attrs
        self.src = src
        self.state = state

        self.command = TuiCommand(src=src)
        self.header = TuiHeader()
        self.outputs = TuiOutputs()
        self.outputs_scroll = None
        self.outputs_title = TuiOutputsTitle()
        self.usage = TuiUsage(src=src)

        self.args: List[str]
        self.input = initial_input
        self.output: str
        self.output_matches: List[str]
        self.propagate_data()
        if self.output not in self.attrs:
            self.input = "/"
            self.propagate_data()

        super().__init__(*args, **kwargs)

    async def on_key(self, event: textual.events.Key) -> None:
        if event.key in {
            textual.keys.Keys.ControlH,
            textual.keys.Keys.Backspace,
        }:
            if len(self.input) >= 2:
                self.input = self.input[:-1]
            self.propagate_data()
        elif event.key == textual.keys.Keys.Down:
            self.outputs_scroll.scroll_up()  # type: ignore
        elif event.key == textual.keys.Keys.Up:
            self.outputs_scroll.scroll_down()  # type: ignore
        elif event.key in {
            textual.keys.Keys.ControlI,
            textual.keys.Keys.Tab,
        }:
            self.propagate_data(autocomplete=True)
        elif event.key == textual.keys.Keys.Enter:
            if self.validate():
                self.state["return"] = [self.output, *self.args]
                await self.action_quit()
        else:
            self.input += event.key
            self.propagate_data(autocomplete=True)
        await self.outputs_scroll.update(self.outputs)  # type: ignore

    def propagate_data(self, autocomplete: bool = False) -> None:
        tokens = self.input.split(" ")
        self.output, *self.args = tokens
        self.output_matches = [
            attr
            for attr in self.attrs
            if attr.lower().startswith(self.output.lower())
        ]
        if autocomplete and self.output_matches:
            self.output = commonprefix(self.output_matches)
        tokens = [self.output, *self.args]

        self.input = " ".join(tokens)
        self.command.input = self.input
        self.outputs_title.output = self.output
        self.outputs.output = self.output
        self.outputs.outputs = self.output_matches
        self.validate()

    def validate(self) -> bool:
        valid: bool = True

        try:
            shlex.split(self.input)
        except ValueError:
            valid = valid and False
        else:
            valid = valid and True

        valid = valid and (self.output in self.attrs)

        self.command.style = "green" if valid else "red"

        return valid

    async def on_mount(self) -> None:
        self.outputs_scroll = textual.widgets.ScrollView(self.outputs)
        grid = await self.view.dock_grid(edge="left")
        grid.add_column(fraction=1, name="c0")
        grid.add_row(size=2, name="r0")
        grid.add_row(size=3, name="r1")
        grid.add_row(size=3, name="r2")
        grid.add_row(size=1, name="r3")
        grid.add_row(size=2, name="r4")
        grid.add_row(fraction=1, name="r5")
        grid.add_areas(
            command="c0,r2",
            header="c0,r0",
            usage="c0,r1",
            outputs="c0,r5",
            outputs_title="c0,r4",
        )
        grid.place(
            command=self.command,
            header=self.header,
            outputs=self.outputs_scroll,
            outputs_title=self.outputs_title,
            usage=self.usage,
        )


def _help_picking_attr(src: str, attrs: List[str]) -> List[str]:
    cache = join(MAKES_DIR, "cache", "last.json")
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
    config: Dict[str, Any] = _get_config(head)
    attrs: List[str] = config["outputs"]
    cache: List[Dict[str, str]] = config["cache"]

    if args[2:]:
        attr: str = args[2]
    elif CON.is_terminal:
        args = [*args[0:2], *_help_picking_attr(src, attrs)]
        attr = args[2]
    else:
        _help_and_exit_with_src_no_tty(src, attrs)

    CON.out()
    CON.rule(f"Building {attr}")
    CON.out()
    if attr not in attrs:
        CON.print(f"We can't proceed with OUTPUT: {attr}", justify="center")
        CON.print("It is not a valid project output", justify="center")
        CON.print()
        CON.print("Please see the correct usage below", justify="center")
        _help_and_exit_with_src_no_tty(src, attrs)

    out: str = join(MAKES_DIR, f"out{attr.replace('/', '-')}")
    code, _, _ = _run(
        args=_nix_build(
            attr=f'config.outputs."{attr}"'
            if NIX_STABLE
            else f'{head}#__makes__."config:outputs:{attr}"',
            cache=cache,
            head=head,
            out=out,
        ),
        env=None if NIX_STABLE else dict(HOME=environ["HOME_IMPURE"]),
        stderr=None,
        stdout=None,
    )
    if code == 0:
        cache_push(cache, out)
        execute_action(args[3:], head, out)
    raise SystemExit(code)


def execute_action(args: List[str], head: str, out: str) -> None:
    action_path: str = join(out, "makes-action.sh")

    if exists(action_path):
        CON.out()
        CON.rule("Running")
        CON.out()
        code, _, _ = _run(
            args=[action_path, out, *args],
            stderr=None,
            stdout=None,
            cwd=head if AWS_BATCH_COMPAT else CWD,
        )
        raise SystemExit(code)


def cache_push(cache: List[Dict[str, str]], out: str) -> None:
    for config in cache:
        if config["type"] == "cachix" and "CACHIX_AUTH_TOKEN" in environ:
            CON.out("Pushing to cache")
            _run(
                args=["cachix", "push", "-c", "0", config["name"], out],
                stderr=None,
                stdout=sys.stderr.fileno(),
            )
            return


def main() -> None:
    try:
        cli(sys.argv)
    except SystemExit as err:
        CON.out()
        if err.code == 0:
            emo = random.choice(EMOJIS_SUCCESS)  # nosec
            CON.rule(f":{emo}: Success!")
        else:
            emo = random.choice(EMOJIS_FAILURE)  # nosec
            CON.rule(f":{emo}: Failed with exit code {err.code}", style="red")
        CON.out()

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
