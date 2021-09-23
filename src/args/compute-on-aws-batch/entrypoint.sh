# shellcheck shell=bash

function subst_env_vars {
  envsubst -no-empty -no-unset < "${1}"
}

function main {
  local job_attempts="__argJobAttempts__"
  local job_attempt_duration_seconds="__argJobAttemptDurationSeconds__"
  local job_container_overrides
  local job_command="__argJobCommand__"
  local job_definition="__argJobDefinition__"
  local job_manifest="__argJobManifest__"
  local job_name="__argJobName__"
  local job_queue="__argJobQueue__"

  info Sending job \
    && job_command="$(subst_env_vars "${job_command}")" \
    && job_command="$(
      jq -enr \
        --argjson job_command "${job_command}" \
        --args \
        '($job_command + $ARGS.positional)' \
        -- \
        "${@}"
    )" \
    && job_manifest="$(subst_env_vars "${job_manifest}")" \
    && job_container_overrides="$(
      jq -enr \
        --argjson job_manifest "${job_manifest}" \
        --argjson job_command "${job_command}" \
        --args \
        '$job_manifest * {
          command: $job_command
        }'
    )" \
    && aws batch submit-job \
      --container-overrides "${job_container_overrides}" \
      --job-name "${job_name}" \
      --job-queue "${job_queue}" \
      --job-definition "${job_definition}" \
      --retry-strategy "attempts=${job_attempts}" \
      --timeout "attemptDurationSeconds=${job_attempt_duration_seconds}" \
    && info Job "${job_name}" has been successfully sentkipped sending it
}

main "${@}"
