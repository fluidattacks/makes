from batch_client import (
    utils,
)
from batch_client.core import (
    DependentJobDraft,
    JobArn,
    JobDependencies,
    JobDraft,
    JobId,
    Manifest,
    ResourceRequirement,
)
from fa_purity import (
    Cmd,
    FrozenList,
)
from fa_purity.cmd import (
    CmdUnwrapper,
)
from fa_purity.pure_iter import (
    PureIterFactory,
)
import logging
from mypy_boto3_batch.client import (
    BatchClient,
)
from mypy_boto3_batch.type_defs import (
    JobDependencyTypeDef,
    KeyValuePairTypeDef,
    ResourceRequirementTypeDef,
    SubmitJobResponseTypeDef,
)
from typing import (
    Dict,
    List,
    Tuple,
)

LOG = logging.getLogger(__name__)


def _encode_req(req: ResourceRequirement) -> ResourceRequirementTypeDef:
    return {
        "type": req.resource.value,
        "value": utils.int_to_str(req.value.to_int),
    }


def _to_pair(key: str, val: str) -> KeyValuePairTypeDef:
    return {
        "name": key,
        "value": val,
    }


def _get_envs(manifest: Manifest) -> Cmd[FrozenList[KeyValuePairTypeDef]]:
    def _action(unwrapper: CmdUnwrapper) -> FrozenList[KeyValuePairTypeDef]:
        return (
            PureIterFactory.from_list(tuple(manifest.environment.items()))
            .map(
                lambda t: _to_pair(
                    t[0],
                    t[1]
                    if isinstance(t[1], str)
                    else unwrapper.act(t[1].get_value()).value_or(""),
                ),
            )
            .to_list()
        )

    return Cmd.new_cmd(_action)


def _decode_respose(
    response: SubmitJobResponseTypeDef,
) -> Tuple[JobId, JobArn]:
    return (JobId(response["jobId"]), JobArn(response["jobArn"]))


def _encode_deps(deps: JobDependencies) -> List[JobDependencyTypeDef]:
    def _transform(_id: JobId) -> JobDependencyTypeDef:
        return {"jobId": _id.raw}

    result = (
        PureIterFactory.from_list(tuple(deps.items)).map(_transform).to_list()
    )
    return list(result)


def send_job(
    client: BatchClient, full_draft: DependentJobDraft
) -> Cmd[Tuple[JobId, JobArn]]:
    draft = full_draft.draft

    def _action(unwrapper: CmdUnwrapper) -> Tuple[JobId, JobArn]:
        env = unwrapper.act(_get_envs(draft.manifest))
        response = (
            client.submit_job(  # pylint: disable=assignment-from-no-return
                arrayProperties={"size": draft.parallel.size.to_int}
                if draft.parallel.size.to_int > 1
                else {},
                containerOverrides={
                    "command": draft.command.raw,
                    "environment": env,
                    "resourceRequirements": PureIterFactory.from_list(
                        draft.manifest.resources
                    )
                    .map(_encode_req)
                    .to_list(),
                },
                jobDefinition=draft.job_def.raw,
                jobName=draft.name.raw,
                jobQueue=draft.queue.raw,
                retryStrategy={
                    "attempts": draft.retries.maximum.to_int,
                },
                tags=dict(draft.tags.items),
                timeout={
                    "attemptDurationSeconds": draft.timeout.seconds.to_int
                },
                propagateTags=draft.propagate_tags,
                dependsOn=full_draft.dependencies.map(_encode_deps).value_or(
                    []
                ),
            )
        )
        return _decode_respose(response)

    return Cmd.new_cmd(_action)
