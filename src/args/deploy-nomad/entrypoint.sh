# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local args=(
    -namespace='__argNamespace__'
  )
  local src='__argSrc__'

  if running_in_ci_cd_provider; then
    info Applying "${src}"
    nomad job run "${args[@]}" "${src}"
  else
    info Planning "${src}"
    nomad job plan "${args[@]}" "${src}"
  fi
}

main "${@}"
