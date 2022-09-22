# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  bandit --recursive "${envTarget}" \
    && touch "${out}"
}

main "${@}"
