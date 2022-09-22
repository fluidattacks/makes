# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  source "${envTargets}/template" local targets

  info Linting Markdown code \
    && for target in "${targets[@]}"; do
      info Linting "${target}" \
        && mdl --ignore-front-matter --style "${envConfig}" "${target}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
