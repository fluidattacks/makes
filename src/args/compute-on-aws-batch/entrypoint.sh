# shellcheck shell=bash

function subst_env_vars {
  envsubst -no-empty -no-unset < "${1}"
}

function main {
  local attempts="__argAttempts__"
  local attempt_duration_seconds="__argAttemptDurationSeconds__"
  local container_overrides
  local command="__argCommand__"
  local definition="__argDefinition__"
  local manifest="__argManifest__"
  local name="__argName__"
  local queue="__argQueue__"

  info Sending job \
    && command="$(subst_env_vars "${command}")" \
    && command="$(
      jq -enr \
        --argjson command "${command}" \
        --args \
        '($command + $ARGS.positional)' \
        -- \
        "${@}"
    )" \
    && manifest="$(subst_env_vars "${manifest}")" \
    && container_overrides="$(
      jq -enr \
        --argjson manifest "${manifest}" \
        --argjson command "${command}" \
        --args \
        '$manifest * {
          command: $command
        }'
    )" \
    && aws batch submit-job \
      --container-overrides "${container_overrides}" \
      --job-name "${name}" \
      --job-queue "${queue}" \
      --job-definition "${definition}" \
      --retry-strategy "attempts=${attempts}" \
      --timeout "attemptDurationSeconds=${attempt_duration_seconds}" \
    && info Job "${name}" has been successfully sent
}

main "${@}"
