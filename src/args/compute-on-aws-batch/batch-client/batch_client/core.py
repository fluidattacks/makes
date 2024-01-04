from __future__ import (
    annotations,
)

from batch_client import (
    utils,
)
from batch_client.utils import (
    Natural,
)
from dataclasses import (
    dataclass,
    field,
)
from enum import (
    Enum,
)
from fa_purity import (
    Cmd,
    FrozenDict,
    FrozenList,
    Maybe,
    PureIter,
    Result,
    ResultE,
)
from fa_purity.pure_iter import (
    PureIterFactory,
    PureIterTransform,
)
import os
from typing import (
    FrozenSet,
)


@dataclass(frozen=True)
class _Private:
    pass


@dataclass(frozen=True)
class QueueName:
    raw: str


@dataclass(frozen=True)
class Attempts:
    _private: _Private = field(repr=False, hash=False, compare=False)
    maximum: Natural

    @staticmethod
    def new(raw: Natural) -> ResultE[Attempts]:
        if raw.to_int <= 10:
            return Result.success(Attempts(_Private(), raw))
        err = ValueError("Attempts must be a Natural <= 10")
        return Result.failure(Exception(err))


@dataclass(frozen=True)
class Timeout:
    _private: _Private = field(repr=False, hash=False, compare=False)
    seconds: Natural

    @staticmethod
    def new(raw: Natural) -> ResultE[Timeout]:
        if raw.to_int >= 60:
            return Result.success(Timeout(_Private(), raw))
        err = ValueError("Timeout must be a Natural >= 60")
        return Result.failure(Exception(err))


@dataclass(frozen=True)
class Command:
    raw: FrozenList[str]


@dataclass(frozen=True)
class JobDefinition:
    raw: str


@dataclass(frozen=True)
class EnvVarPointer:
    name: str

    def get_value(self) -> Cmd[Maybe[str]]:
        return Cmd.from_cmd(
            lambda: Maybe.from_optional(os.environ.get(self.name))
        )


class ResourceType(Enum):
    VCPU = "VCPU"
    MEMORY = "MEMORY"

    @staticmethod
    def to_req_type(raw: str) -> ResultE[ResourceType]:
        return utils.handle_value_error(lambda: ResourceType(raw.upper()))


@dataclass(frozen=True)
class ResourceRequirement:
    resource: ResourceType
    value: Natural


@dataclass(frozen=True)
class Tags:
    items: FrozenDict[str, str]


@dataclass(frozen=True)
class Manifest:
    environment: FrozenDict[str, str | EnvVarPointer]
    resources: FrozenList[ResourceRequirement]


@dataclass(frozen=True)
class JobSize:
    size: Natural

    @staticmethod
    def new(raw: Natural) -> ResultE[Attempts]:
        if raw.to_int >= 1 and raw.to_int <= 10000:
            return Result.success(Attempts(_Private(), raw))
        err = ValueError("JobSize must be a Natural between 1 and 10000")
        return Result.failure(Exception(err))


class JobStatus(Enum):
    SUBMITTED = "SUBMITTED"
    PENDING = "PENDING"
    RUNNABLE = "RUNNABLE"
    STARTING = "STARTING"
    RUNNING = "RUNNING"
    SUCCEEDED = "SUCCEEDED"
    FAILED = "FAILED"

    @staticmethod
    def to_status(raw: str) -> ResultE[JobStatus]:
        return utils.handle_value_error(lambda: JobStatus(raw.upper()))


@dataclass(frozen=True)
class JobName:
    _private: _Private = field(repr=False, hash=False, compare=False)
    raw: str

    @staticmethod
    def new(raw: str) -> ResultE[JobName]:
        def _check(index: int, char: str) -> bool:
            if index == 1:
                return char.isalnum()
            return char.isalnum() or char in ["_", "-"]

        validation = (
            PureIterFactory.from_list(tuple(raw))
            .enumerate(1)
            .map(lambda t: _check(*t))
        )
        if len(raw) <= 128 and all(validation):
            return Result.success(JobName(_Private(), raw))
        err = ValueError("JobName does not fulfill naming rules")
        return Result.failure(Exception(err))

    @staticmethod
    def normalize(raw: str) -> JobName:
        def _normalize(index: int, char: str) -> str:
            if index == 1 and not char.isalnum():
                return "X"
            if char.isalnum() or char in ["_"]:
                return char
            else:
                return "-"

        text = (
            PureIterFactory.from_list(tuple(raw))
            .enumerate(1)
            .map(lambda t: (t[0], _normalize(*t)))
        )
        truncated = PureIterTransform.until_none(
            text.map(lambda t: t[1] if t[0] <= 128 else None)
        )
        return JobName(_Private(), "".join(truncated))


@dataclass(frozen=True)
class JobId:
    raw: str


@dataclass(frozen=True)
class JobArn:
    raw: str


@dataclass(frozen=True)
class JobDependencies:
    _private: _Private = field(repr=False, hash=False, compare=False)
    items: FrozenSet[JobId]

    @staticmethod
    def new(items: FrozenSet[JobId]) -> ResultE[JobDependencies]:
        if len(items) >= 1 and len(items) <= 20:
            return Result.success(JobDependencies(_Private(), items))
        err = ValueError("The maximun number of dependencies for a job is 20")
        return Result.failure(Exception(err))


@dataclass(frozen=True)
class BatchJob:
    created_at: int
    status: JobStatus
    status_reason: Maybe[str]
    started_at: Maybe[int]
    stoped_at: Maybe[int]


@dataclass(frozen=True)
class BatchJobObj:
    job_id: JobId
    arn: JobArn
    name: JobName
    job: BatchJob


@dataclass(frozen=True)
class RawJobDraft:
    name: str
    queue: Maybe[str]
    command: FrozenList[str]
    job_def: str
    retries: int
    timeout: int
    env: FrozenList[FrozenDict[str, str]]
    memory: int
    vcpus: int
    size: int
    tags: FrozenDict[str, str]
    allow_duplicates: bool
    args_in_name: bool
    propagate_tags: bool
    dry_run: bool
    next_job: Maybe[RawJobDraft]


@dataclass(frozen=True)
class JobDraft:
    name: JobName
    queue: QueueName
    parallel: JobSize
    job_def: JobDefinition
    retries: Attempts
    timeout: Timeout
    command: Command
    manifest: Manifest
    tags: Tags
    propagate_tags: bool


@dataclass(frozen=True)
class DependentJobDraft:
    draft: JobDraft
    dependencies: Maybe[JobDependencies]


@dataclass(frozen=True)
class AllowDuplicates:
    value: bool


@dataclass(frozen=True)
class JobPipelineDraft:
    drafts: PureIter[JobDraft]
    allow_duplicates: bool
    dry_run: bool
