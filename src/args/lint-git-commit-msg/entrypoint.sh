# shellcheck shell=bash

function main {
  local commit_diff
  local commit_hashes
  local main_branch=__argBranch__
  local args=(
    --parser-preset __argParser__
    --config __argConfig__
  )
  local commitlint_path="src/args/lint-git-commit-msg/commitlint"

  pushd "${commitlint_path}" \
    && npm ci \
    && export PATH="${PWD}/node_modules/.bin:${PATH}" \
    && popd \
    && pushd __argSrc__ \
    && commit_diff="origin/${main_branch}..HEAD" \
    && commit_hashes="$(git --no-pager log --pretty=%h "${commit_diff}")" \
    && for commit_hash in ${commit_hashes}; do
      info "Linting ${commit_hash}" \
        && git log -1 --pretty=%B "${commit_hash}" | commitlint "${args[@]}" \
        || return 1
    done
}

main "${@}"
