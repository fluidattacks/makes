# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  source __argArgs__/template local args
  local output=__argOutput__

  if test -e "${output}/makes-action.sh"; then
    "${output}/makes-action.sh" "${output}" "${args[@]}"
  fi
}

main "${@}"
