# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local commit_diff
  local commit_hashes
  local main_branch=__argBranch__
  local args=(
    --parser-preset __argParser__
    --config __argConfig__
  )

  cd __argSrc__ \
    && commit_diff="origin/${main_branch}..HEAD" \
    && commit_hashes="$(git --no-pager log --pretty=%h "${commit_diff}")" \
    && for commit_hash in ${commit_hashes}; do
      info "Linting ${commit_hash}" \
        && git log -1 --pretty=%B "${commit_hash}" | commitlint "${args[@]}" \
        || return 1
    done
}

main "${@}"
