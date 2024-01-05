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
    JobPipelineDraft,
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


@click.command()
@click.option("--pipeline", type=click.Path(exists=True), required=True)
@click.argument("args", nargs=-1)
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
    pipeline_draft = _queue_from_env.bind(
        lambda queue: _root.map(
            lambda root: decode.decode_all_drafts(root, arg_groups, queue)
        )
    )

    def _execute(draft: JobPipelineDraft) -> Cmd[None]:
        # Handle dry run logic
        action = new_client().bind(
            lambda c: utils.extract_single(draft.drafts).map(
                lambda j: actions.send_single_job(
                    c, j, draft.allow_duplicates
                ),
                lambda p: actions.send_pipeline(c, p),
            )
        )
        if draft.dry_run:
            return Cmd.from_cmd(lambda: None)
        return action

    cmd: Cmd[None] = pipeline_draft.bind(_execute)
    cmd.compute()


@click.group()
def main() -> None:
    pass


main.add_command(submit_job)
