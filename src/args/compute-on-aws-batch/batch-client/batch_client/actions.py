from .api import (
    ApiClient,
)
from batch_client.core import (
    DependentJobDraft,
    JobDependencies,
    JobDraft,
    JobId,
    JobStatus,
)
from fa_purity import (
    Cmd,
    Maybe,
    PureIter,
)
from fa_purity.cmd import (
    CmdUnwrapper,
)
import logging

LOG = logging.getLogger(__name__)


def send_single_job(
    client: ApiClient,
    draft: JobDraft,
    allow_duplicates: bool,
) -> Cmd[None]:
    dup_msg = Cmd.from_cmd(lambda: LOG.info("Detecting duplicates..."))
    skipped_msg = Cmd.from_cmd(
        lambda: LOG.warning("Duplicated job detected. Skipping job submission")
    )
    allow_send = (
        Cmd.from_cmd(lambda: LOG.warning("Duplicated jobs are allowed")).map(
            lambda _: True
        )
        if allow_duplicates
        else dup_msg
        + client.list_jobs(draft.name, draft.queue, JobStatus.RUNNABLE)
        .find_first(lambda _: True)
        .map(lambda m: m.map(lambda _: False).value_or(True))
    )
    return allow_send.bind(
        lambda b: Cmd.from_cmd(
            lambda: LOG.info("Submiting job: %s", draft.name.raw)
        )
        + client.send_job(DependentJobDraft(draft, Maybe.empty())).bind(
            lambda j: Cmd.from_cmd(
                lambda: LOG.info("Job sent! id=%s arn=%s", j[0].raw, j[1].raw)
            )
        )
        if b
        else skipped_msg
    )


def send_pipeline(
    client: ApiClient, pipeline: PureIter[JobDraft]
) -> Cmd[None]:
    def _action(unwrapper: CmdUnwrapper) -> None:
        prev: Maybe[JobId] = Maybe.empty()
        LOG.info("Submiting jobs pipeline...")
        for draft in pipeline:
            send = client.send_job(
                DependentJobDraft(
                    draft,
                    prev.map(
                        lambda j: JobDependencies.new(frozenset([j])).unwrap()
                    ),
                )
            )
            LOG.info("Submiting job: %s", draft.name.raw)
            sent_id = unwrapper.act(send)
            LOG.info("Job sent! id=%s arn=%s", sent_id[0].raw, sent_id[1].raw)
            prev = Maybe.from_value(sent_id[0])

    return Cmd.new_cmd(_action)
