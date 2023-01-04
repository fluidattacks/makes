# shellcheck shell=bash

function is_git_repository {
  local path="${1}"

  git -C "${path}" rev-parse 2> /dev/null
}

function require_git_repository {
  local path="${1}"

  if ! is_git_repository "${path}"; then
    critical We require a git repository, but this one is not: "${path}"
  fi
}

function get_abbrev_rev {
  local path="${1}"
  local rev="${2}"

  require_git_repository "${path}" \
    && git -C "${path}" rev-parse --abbrev-ref "${rev}"
}

function get_commit_from_rev {
  local path="${1}"
  local rev="${2}"

  require_git_repository "${path}" \
    && git -C "${path}" rev-parse "${rev}"
}
