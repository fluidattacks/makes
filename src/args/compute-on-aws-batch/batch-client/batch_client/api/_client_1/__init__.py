from . import (
    _list_jobs,
    _send_job,
)
from batch_client.api._core import (
    ApiClient,
)
import boto3
from fa_purity import (
    Cmd,
)
from fa_purity.date_time import (
    DatetimeFactory,
)
from mypy_boto3_batch.client import (
    BatchClient,
)


def _new_batch_client() -> Cmd[BatchClient]:
    def _action() -> BatchClient:
        return boto3.client("batch")

    return Cmd.from_cmd(_action)


def new_client() -> Cmd[ApiClient]:
    return _new_batch_client().map(
        lambda client: ApiClient(
            lambda n, q, s: _list_jobs.list_jobs(client, n, q, s),
            lambda j: _send_job.send_job(client, j),
        )
    )
