# shellcheck shell=bash

function populate {
  source __argData__/template local root_paths

  for root_path in "${root_paths[@]}"; do
    info "Wirting data from root directory: ${root_path}" \
      && if [[ ${root_path} != */ ]]; then
        root_path="${root_path}/"
      fi \
      && for data in "${root_path}"*'.json'; do
        echo "[INFO] Writing data from: ${data}" \
          && aws dynamodb batch-write-item \
            --endpoint-url "http://${HOST}:${PORT}" \
            --request-items "file://${data}" \
          || return 1
      done
  done
}

function serve_daemon {
  kill_port "2${PORT}" \
    && { serve "${@}" & } \
    && wait_port 300 "${HOST}:2${PORT}"
}

function serve {
  info 'Unpacking DynamoDB' \
    && rm -rf "${STATE_PATH}" \
    && mkdir -p "${STATE_PATH}" \
    && pushd "${STATE_PATH}" \
    && unzip -u '__argDynamoZip__' \
    && popd \
    && info 'Deleting old instance, if exists' \
    && kill_port "${PORT}" "2${PORT}" \
    && info 'Launching DynamoDB' \
    && {
      java \
        -Djava.library.path="${STATE_PATH}/DynamoDBLocal_lib" \
        -jar "${STATE_PATH}/DynamoDBLocal.jar" \
        -inMemory \
        -port "${PORT}" \
        -sharedDb &
    } \
    && wait_port 10 "${HOST}:${PORT}" \
    && if ! test -z '__argInfra__'; then
      copy '__argInfra__' "${STATE_PATH}/terraform" \
        && pushd "${STATE_PATH}/terraform" \
        && terraform init \
        && terraform apply -auto-approve \
        && popd \
        && if { test '__argShouldPopulate__' == '1' || test "${POPULATE-}" = 'true'; } && test "${POPULATE-}" != 'false'; then
          populate
        fi
    fi \
    && done_port "${HOST}" "2${PORT}" \
    && info 'Dynamo DB is ready' \
    && wait
}

function main {
  export HOST="${HOST:-__argHost__}"
  export PORT="${PORT:-__argPort__}"

  export AWS_ACCESS_KEY_ID='test'
  export AWS_SECRET_ACCESS_KEY='test'
  export AWS_DEFAULT_REGION='us-east-1'

  export TF_VAR_host="${HOST}"
  export TF_VAR_port="${PORT}"

  STATE_PATH="$(mktemp -d)"
  export STATE_PATH

  if { test "${DAEMON-}" = "true" || test '__argDaemonMode__' == 1; } && test "${DAEMON-}" != "false"; then
    serve_daemon "${@}"
  else
    serve "${@}"
  fi
}

main "${@}"
