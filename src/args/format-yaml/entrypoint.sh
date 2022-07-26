# shellcheck shell=bash

function diff {
  git --no-pager diff -G. --no-index "${1}" "${2}" > /dev/null
}

function main {
  source __argTargets__/template local targets
  local tmp_paths
  local tmp_file
  local exit_code="0"

  info "Formatting YAML files" \
    && tmp_paths=$(mktemp) \
    && for target in "${targets[@]}"; do
      find "${target}" -wholename '*.yml' -or -wholename '*.yaml' -type f \
        | sort --ignore-case > "${tmp_paths}" \
        && while read -r path; do
          tmp_file=$(mktemp) \
            && copy "${path}" "${tmp_file}" \
            && yamlfix "${path}" 2> /dev/null \
            && if ! diff "${tmp_file}" "${path}"; then
              info "This file does not comply the format. We just formatted it: ${path} " \
                && exit_code="1"
            fi \
            || return 1
        done < "${tmp_paths}" \
        || return 1
    done \
    && return "${exit_code}"
}

main "${@}"
