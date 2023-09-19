from . import (
    actions,
    decode,
    utils,
)
from .api import (
    new_client,
)
from .core import (
    EnvVarPointer,
    QueueName,
)
import click
from fa_purity import (
    Cmd,
    FrozenList,
)
from fa_purity.json_2.value import (
    JsonObj,
    UnfoldedFactory,
)
from fa_purity.pure_iter import (
    PureIterFactory,
)
import itertools
from typing import (
    NoReturn,
)


def _decode_json(file_path: str) -> Cmd[JsonObj]:
    def _action() -> JsonObj:
        with open(file_path, "r", encoding="utf-8") as file:
            raw = UnfoldedFactory.load(file).unwrap()
        return raw

    return Cmd.from_cmd(_action)


@click.command()  # type: ignore[misc]
@click.option("--pipeline", type=click.Path(exists=True), required=True)  # type: ignore[misc]
@click.argument("args", nargs=-1)  # type: ignore[misc]
def submit_job(
    pipeline: str,
    args: FrozenList[str],
) -> NoReturn:
    _queue_from_env = (
        EnvVarPointer("MAKES_COMPUTE_ON_AWS_BATCH_QUEUE")
        .get_value()
        .map(
            lambda m: m.map(QueueName)
            .to_result()
            .alt(
                lambda _: Exception(
                    "Required env var: MAKES_COMPUTE_ON_AWS_BATCH_QUEUE"
                )
            )
        )
    )
    _root = (
        _decode_json(pipeline)
        .map(decode.decode_raw_draft)
        .map(lambda r: r.unwrap().unwrap())
    )

    def _sep(item: str) -> bool:
        return item == "---"

    _arg_groups = tuple(
        list(g) for k, g in itertools.groupby(args, _sep) if not k
    )
    arg_groups = (
        PureIterFactory.from_list(_arg_groups)
        .map(lambda x: tuple(x))
        .to_list()
    )
    drafts = _queue_from_env.bind(
        lambda queue: _root.map(
            lambda root: decode.decode_all_drafts(root, arg_groups, queue)
        )
    ).map(
        lambda t: (
            t[0].map(
                lambda r: r.alt(
                    lambda e: Exception(f"Invalid job draft i.e. {e}")
                ).unwrap()
            ),
            t[1],
        )
    )
    cmd: Cmd[None] = drafts.bind(
        lambda d: new_client().bind(
            lambda c: utils.extract_single(d[0]).map(
                lambda j: actions.send_single_job(c, j, d[1]),
                lambda p: actions.send_pipeline(c, p),
            )
        )
    )
    cmd.compute()


@click.group()  # type: ignore[misc]
def main() -> None:
    pass


main.add_command(submit_job)
