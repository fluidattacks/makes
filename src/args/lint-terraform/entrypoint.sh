# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local src='__argSrc__'
  local cfg='__argConfig__'

  pushd "${src}" \
    && info Initializing "${src}" \
    && terraform init \
    && info Linting "${src}" \
    && info "${cfg}" \
    && tflint --config="${cfg}" --init
}

main "${@}"
