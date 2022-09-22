# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local args=(
    -refresh=true
  )
  local src='__argSrc__'

  pushd "${src}" \
    && info Initializing "${src}" \
    && terraform init \
    && info Applying "${src}" \
    && if running_in_ci_cd_provider; then
      args+=(-auto-approve)
    fi \
    && terraform apply "${args[@]}"
}

main "${@}"
