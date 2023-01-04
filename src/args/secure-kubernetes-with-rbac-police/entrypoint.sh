# shellcheck shell=bash

function evaluate {
  local output="${1}"
  local evaluated
  local passed

  : \
    && if ! echo "${output}" | jq -rec &> /dev/null; then
      warn "Kubernetes cluster could not be reached." \
        && error "${output}"
    fi \
    && evaluated="$(echo "${output}" | jq -rec .summary.evaluated)" \
    && passed="$(echo "${output}" | jq -rec .summary.passed)" \
    && echo "${output}" | jq -re \
    && if [ "${passed}" != "${evaluated}" ]; then
      return 1
    fi
}

function main {
  local output

  : \
    && pushd "__argRepo__" \
    && output="$("__argBin__" "eval" "lib/" -s "__argSeverity__" 2>&1)" \
    && popd \
    && evaluate "${output}" \
    || return 1
}

main "${@}"
