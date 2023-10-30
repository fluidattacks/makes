from os.path import (
    commonprefix,
)
import rich.align
import rich.console
import rich.markup
import rich.panel
import rich.table
import rich.text
import shlex
import textual.app
import textual.events
import textual.keys
import textual.reactive
import textual.widget
import textual.widgets
from typing import (
    Any,
    Dict,
    List,
)


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
    outputs: textual.reactive.Reactive = textual.reactive.Reactive([])

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
        return rich.align.Align(text, align="center")  # type: ignore


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
        self.outputs_scroll: Any = None
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
            self.outputs_scroll.scroll_up()
        elif event.key == textual.keys.Keys.Up:
            self.outputs_scroll.scroll_down()
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
        await self.outputs_scroll.update(self.outputs)

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
