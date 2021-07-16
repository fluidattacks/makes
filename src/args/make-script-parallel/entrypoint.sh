# shellcheck shell=bash

function main {
  local commands=__argCommands__
  local parallel_args=__argParallelArgs__
  local commands_file

  commands_file="$(mktemp)" \
    && for command in "${commands[@]}"; do
      echo "${command}" >> "${commands_file}"
    done \
    && parallel "${parallel_args[@]}" < "${commands_file}"
}

main "${@}"
