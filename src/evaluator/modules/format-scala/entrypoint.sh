# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  source __argTargets__/template local targets

  for target in "${targets[@]}"; do
    '__argScalaFmtBinary__' "${target}"
  done
}

main "${@}"
