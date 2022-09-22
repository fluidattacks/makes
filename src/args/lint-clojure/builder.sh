# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local args=(
    --lint
  )

  info Linting Clojure solution \
    && clj-kondo "${args[@]}" "${envTarget}" \
    && touch "${out}"
}

main "${@}"
