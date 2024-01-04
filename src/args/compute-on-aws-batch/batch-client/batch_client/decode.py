from __future__ import (
    annotations,
)

from batch_client import (
    utils,
)
from batch_client.core import (
    Attempts,
    Command,
    EnvVarPointer,
    JobDefinition,
    JobDraft,
    JobName,
    JobPipelineDraft,
    JobSize,
    Manifest,
    QueueName,
    RawJobDraft,
    ResourceRequirement,
    ResourceType,
    Tags,
    Timeout,
)
from batch_client.utils import (
    Natural,
    ResultUnwrapper,
)
from collections.abc import (
    Callable,
)
from fa_purity import (
    FrozenDict,
    FrozenList,
    Maybe,
    PureIter,
    Result,
    ResultE,
)
from fa_purity.json_2 import (
    JsonObj,
    JsonPrimitiveUnfolder,
    JsonUnfolder,
    JsonValue,
    Unfolder,
)
from fa_purity.pure_iter import (
    PureIterFactory,
    PureIterTransform,
)
from fa_purity.result import (
    ResultFactory,
)
from fa_purity.result.transform import (
    all_ok,
)
from typing import (
    Tuple,
    TypeVar,
)

_T = TypeVar("_T")


def _require(
    item: JsonObj, key: str, transform: Callable[[JsonValue], ResultE[_T]]
) -> ResultE[_T]:
    return JsonUnfolder.require(item, key, transform).alt(
        lambda e: Exception(f"Error at key `{key}` i.e. {e}")
    )


def _to_str(raw: JsonValue) -> ResultE[str]:
    return Unfolder.to_primitive(raw).bind(JsonPrimitiveUnfolder.to_str)


def _to_int(raw: JsonValue) -> ResultE[int]:
    return Unfolder.to_primitive(raw).bind(JsonPrimitiveUnfolder.to_int)


def _to_bool(raw: JsonValue) -> ResultE[bool]:
    return Unfolder.to_primitive(raw).bind(JsonPrimitiveUnfolder.to_bool)


def _decode_env_pair(
    raw: FrozenDict[str, str]
) -> ResultE[Tuple[str, str | EnvVarPointer]]:
    name = (
        Maybe.from_optional(raw.get("name"))
        .to_result()
        .alt(lambda _: KeyError("name"))
        .alt(Exception)
    )
    value = Maybe.from_optional(raw.get("value"))
    return name.map(lambda n: (n, value.value_or(EnvVarPointer(n))))


def _decode_envs(
    raw: FrozenList[FrozenDict[str, str]],
) -> ResultE[FrozenDict[str, str | EnvVarPointer]]:
    _decoded = PureIterFactory.from_list(raw).map(_decode_env_pair)
    return all_ok(_decoded.to_list()).map(lambda i: FrozenDict(dict(i)))


def _decode_raw_draft(raw: JsonObj, unwrapper: ResultUnwrapper) -> RawJobDraft:
    _name = _require(raw, "name", _to_str)
    _queue = _require(
        raw,
        "queue",
        lambda j: Unfolder.to_primitive(j).bind(
            JsonPrimitiveUnfolder.to_opt_str
        ),
    ).map(lambda x: Maybe.from_optional(x))
    _command = _require(
        raw, "command", lambda e: Unfolder.to_list_of(e, _to_str)
    )
    _job_def = _require(raw, "definition", _to_str)
    _retries = _require(raw, "attempts", _to_int)
    _timeout = _require(raw, "attemptDurationSeconds", _to_int)
    _env = _require(
        raw,
        "environment",
        lambda e: Unfolder.to_list_of(
            e, lambda j: Unfolder.to_dict_of(j, _to_str)
        ),
    )
    _memory = _require(raw, "memory", _to_int)
    _vcpus = _require(raw, "vcpus", _to_int)
    _size = _require(raw, "parallel", _to_int)
    _tags = _require(raw, "tags", lambda j: Unfolder.to_dict_of(j, _to_str))
    _allow_duplicates = _require(raw, "allowDuplicates", _to_bool)
    _args_in_name = _require(raw, "includePositionalArgsInName", _to_bool)
    _propagate_tags = _require(raw, "propagateTags", _to_bool)
    _dry_run = _require(raw, "dryRun", _to_bool)
    _next = _require(raw, "nextJob", Unfolder.to_json).bind(decode_raw_draft)
    return RawJobDraft(
        unwrapper.unwrap(_name),
        unwrapper.unwrap(_queue),
        unwrapper.unwrap(_command),
        unwrapper.unwrap(_job_def),
        unwrapper.unwrap(_retries),
        unwrapper.unwrap(_timeout),
        unwrapper.unwrap(_env),
        unwrapper.unwrap(_memory),
        unwrapper.unwrap(_vcpus),
        unwrapper.unwrap(_size),
        unwrapper.unwrap(_tags),
        unwrapper.unwrap(_allow_duplicates),
        unwrapper.unwrap(_args_in_name),
        unwrapper.unwrap(_propagate_tags),
        unwrapper.unwrap(_dry_run),
        unwrapper.unwrap(_next),
    )


def decode_raw_draft(raw: JsonObj) -> ResultE[Maybe[RawJobDraft]]:
    if raw == FrozenDict({}):
        return Result.success(Maybe.empty())
    return (
        utils.unwrap_context(lambda u: _decode_raw_draft(raw, u))
        .map(lambda x: Maybe.from_value(x))
        .alt(
            lambda e: Exception(
                f"decode_raw_draft failed i.e. {e} with data {Unfolder.dumps(raw)}"
            )
        )
    )


def _from_raw_draft(
    raw: RawJobDraft, args: FrozenList[str], queue_from_env: ResultE[QueueName]
) -> ResultE[JobDraft]:
    name = JobName.normalize(
        raw.name + ("-" if len(args) > 0 else "") + "-".join(args)
        if raw.args_in_name
        else raw.name
    )
    _factory: ResultFactory[QueueName, Exception] = ResultFactory()
    _queue = raw.queue.map(
        lambda q: _factory.success(QueueName(q))
        if len(q) > 0
        else queue_from_env
    ).value_or(queue_from_env)
    size = JobSize(Natural.abs(raw.size))
    job_def = JobDefinition(raw.job_def)
    _attempts = Attempts.new(Natural.abs(raw.retries))
    _timeout = Timeout.new(Natural.abs(raw.timeout))
    command = Command(raw.command + args)
    reqs = (
        ResourceRequirement(ResourceType.MEMORY, Natural.abs(raw.memory)),
        ResourceRequirement(ResourceType.VCPU, Natural.abs(raw.vcpus)),
    )
    _manifest = _decode_envs(raw.env).map(
        lambda envs: Manifest(
            envs,
            reqs,
        )
    )

    def _context(unwrapper: ResultUnwrapper) -> JobDraft:
        return JobDraft(
            name,
            unwrapper.unwrap(_queue),
            size,
            job_def,
            unwrapper.unwrap(_attempts),
            unwrapper.unwrap(_timeout),
            command,
            unwrapper.unwrap(_manifest),
            Tags(raw.tags),
            raw.propagate_tags,
        )

    return utils.unwrap_context(_context)


def _raw_jobs(raw: RawJobDraft) -> PureIter[RawJobDraft]:
    return PureIterFactory.infinite_gen(
        lambda m: m.bind(lambda r: r.next_job), Maybe.from_value(raw)
    ).transform(lambda i: PureIterTransform.until_empty(i))


def decode_all_drafts(
    root: RawJobDraft,
    args: FrozenList[FrozenList[str]],
    queue_from_env: ResultE[QueueName],
) -> JobPipelineDraft:
    items = (
        _raw_jobs(root)
        .enumerate(0)
        .map(
            lambda t: _from_raw_draft(
                t[1],
                utils.get_index(args, t[0]).value_or(tuple([])),
                queue_from_env,
            )
        )
    )
    drafts = items.map(
        lambda r: r.alt(
            lambda e: Exception(f"Invalid job draft i.e. {e}")
        ).unwrap()
    )
    return JobPipelineDraft(drafts, root.allow_duplicates, root.dry_run)
