from batch_client.core import (
    BatchJobObj,
    DependentJobDraft,
    JobArn,
    JobId,
    JobName,
    JobStatus,
    QueueName,
)
from collections.abc import (
    Callable,
)
from dataclasses import (
    dataclass,
)
from fa_purity import (
    Cmd,
    Stream,
)
from typing import (
    Tuple,
)


@dataclass(frozen=True)
class ApiClient:
    list_jobs: Callable[[JobName, QueueName, JobStatus], Stream[BatchJobObj]]
    send_job: Callable[[DependentJobDraft], Cmd[Tuple[JobId, JobArn]]]
