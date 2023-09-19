from batch_client import (
    utils,
)
from batch_client.core import (
    BatchJob,
    BatchJobObj,
    JobArn,
    JobId,
    JobName,
    JobStatus,
    QueueName,
)
from dataclasses import (
    dataclass,
)
from fa_purity import (
    Cmd,
    FrozenList,
    Maybe,
    ResultE,
    Stream,
)
from fa_purity.date_time import (
    DatetimeUTC,
)
from fa_purity.pure_iter import (
    PureIterFactory,
)
from fa_purity.result.transform import (
    all_ok,
)
from fa_purity.stream import (
    StreamFactory,
    StreamTransform,
)
from fa_purity.utils import (
    raise_exception,
)
from mypy_boto3_batch.client import (
    BatchClient,
)
from mypy_boto3_batch.type_defs import (
    JobSummaryTypeDef,
    KeyValuesPairTypeDef,
    ListJobsResponseTypeDef,
)


def _decode_job(raw: JobSummaryTypeDef) -> ResultE[BatchJob]:
    def _inner() -> ResultE[BatchJob]:
        return JobStatus.to_status(raw["status"]).map(
            lambda status: BatchJob(
                raw["createdAt"],
                status,
                Maybe.from_optional(raw.get("statusReason")),
                Maybe.from_optional(raw.get("startedAt")),
                Maybe.from_optional(raw.get("stoppedAt")),
            )
        )

    return utils.handle_key_error(_inner).bind(lambda x: x)


def _decode_job_obj(
    raw: JobSummaryTypeDef,
) -> ResultE[BatchJobObj]:
    def _inner() -> ResultE[BatchJobObj]:
        _arn = JobArn(raw["jobArn"])
        _id = JobId(raw["jobId"])
        _name = JobName.new(raw["jobName"])
        return _name.bind(
            lambda name: _decode_job(raw).map(
                lambda j: BatchJobObj(_id, _arn, name, j)
            )
        )

    return utils.handle_key_error(_inner).bind(lambda x: x)


@dataclass
class JobsPage:
    items: FrozenList[BatchJobObj]
    next_item: Maybe[str]


def _decode_respose(response: ListJobsResponseTypeDef) -> ResultE[JobsPage]:
    def _inner() -> ResultE[JobsPage]:
        items = PureIterFactory.from_list(response["jobSummaryList"]).map(
            _decode_job_obj
        )
        _next = Maybe.from_optional(response.get("nextToken"))
        return all_ok(items.to_list()).map(lambda i: JobsPage(i, _next))

    return utils.handle_key_error(_inner).bind(lambda x: x)


def _list_jobs_page(
    client: BatchClient,
    queue: QueueName,
    name: JobName,
    _next: Maybe[str],
) -> Cmd[JobsPage]:
    def _action() -> JobsPage:
        _filter: FrozenList[KeyValuesPairTypeDef] = (
            {"name": "JOB_NAME", "values": [name.raw]},
        )
        result = _next.map(
            lambda n: client.list_jobs(
                jobQueue=queue.raw, filters=_filter, nextToken=n
            )
        ).or_else_call(
            lambda: client.list_jobs(jobQueue=queue.raw, filters=_filter)
        )
        return _decode_respose(result).alt(raise_exception).unwrap()

    return Cmd.from_cmd(_action)


def list_jobs(
    client: BatchClient,
    name: JobName,
    queue: QueueName,
    status: JobStatus,
) -> Stream[BatchJobObj]:
    def _extract(page: JobsPage) -> Maybe[Maybe[str]]:
        return page.next_item.map(lambda n: Maybe.from_value(n))

    def _cmd(index: Maybe[str]) -> Cmd[JobsPage]:
        return _list_jobs_page(client, queue, name, index)

    return (
        StreamFactory.generate(_cmd, _extract, Maybe.empty(str))
        .map(lambda j: PureIterFactory.from_list(j.items))
        .transform(lambda x: StreamTransform.chain(x))
        .filter(lambda j: j.job.status == status)
    )
