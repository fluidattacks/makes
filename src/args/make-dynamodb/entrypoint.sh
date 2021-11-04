# shellcheck shell=bash

function serve {
  info 'Unpacking DynamoDB' \
    && rm -rf "${STATE_PATH}" \
    && mkdir -p "${STATE_PATH}" \
    && pushd "${STATE_PATH}" \
    && unzip -u '__argDynamoZip__' \
    && popd \
    && info 'Deleting old instance, if exists' \
    && kill_port "${PORT}" \
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
    && info 'Dynamo DB is ready' \
    && wait
}

function main {
  export HOST='__argHost__'
  export PORT='__argPort__'

  STATE_PATH="$(mktemp -d)"
  export STATE_PATH

  serve "${@}"
}

main "${@}"
