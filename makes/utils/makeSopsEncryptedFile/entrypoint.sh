# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local key="${1}"
  local output="${2}"

  sops --encrypt --kms "${key}" "__argTemplate__" > "${output}"
}

main "${@}"
