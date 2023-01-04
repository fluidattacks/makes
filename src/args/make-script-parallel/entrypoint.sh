# shellcheck shell=bash

function main {
  source __argCommands__/template local commands
  source __argParallelArgs__/template local parallel_args
  local commands_file

  commands_file="$(mktemp)" \
    && for command in "${commands[@]}"; do
      echo "${command}" >> "${commands_file}"
    done \
    && parallel "${parallel_args[@]}" < "${commands_file}"
}

main "${@}"
