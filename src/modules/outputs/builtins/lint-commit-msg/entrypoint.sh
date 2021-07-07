# shellcheck shell=bash

function main {
  local commit_diff
  local commit_hashes
  local current_branch
  local main_branch=__envBranch__
  local ci="${!__envCI__:-}"

  current_branch="$(git rev-parse --abbrev-ref HEAD)" \
    && git fetch --prune > /dev/null \
    && if test -n "${ci:-}"; then
      commit_diff="origin/${main_branch}..origin/${current_branch}"
    else
      commit_diff="origin/${main_branch}..${current_branch}"
    fi \
    && commit_hashes="$(git log --pretty=%h "${commit_diff}")" \
    && for commit_hash in ${commit_hashes}; do
      git log -1 --pretty=%B "${commit_hash}" | commitlint \
        || return 1
    done
}

main "${@}"
