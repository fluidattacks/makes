# shellcheck shell=bash

function main {
  local src='__argSrc__'
  local cfg='__argConfig__'

  pushd "${src}" \
    && info Initializing "${src}" \
    && terraform init \
    && info Linting "${src}" \
    && info "${cfg}" \
    && tflint --config="${cfg}" --init \
    && tflint --config="${cfg}"
}

main "${@}"
