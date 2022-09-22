# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  cd '__argSrc__' \
    && mailmap-linter
}

main "${@}"
