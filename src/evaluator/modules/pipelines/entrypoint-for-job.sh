# shellcheck shell=bash

function main {
  source __argArgs__/template local args
  local output=__argOutput__

  if test -e "${output}/makes-action.sh"; then
    "${output}/makes-action.sh" "${output}" "${args[@]}"
  fi
}

main "${@}"
