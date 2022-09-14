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
  local bin
  local output

  : \
    && bin="$(mktemp)" \
    && copy "__argBin__" "${bin}" \
    && chmod +x "${bin}" \
    && pushd "__argRepo__" \
    && output="$("${bin}" "eval" "lib/" -s "__argSeverity__" 2>&1)" \
    && popd \
    && evaluate "${output}" \
    || return 1
}

main "${@}"
