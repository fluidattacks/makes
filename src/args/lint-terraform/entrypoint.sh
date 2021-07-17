# shellcheck shell=bash

function main {
  cd "$(mktemp -d)" \
    && copy '__argSrc__' . \
    && info Initializing '__argSrc__' \
    && terraform init \
    && info Linting '__argSrc__' \
    && tflint -c '__argConfig__'
}

main "${@}"
