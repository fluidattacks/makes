# shellcheck shell=bash

function is_up_to_date {
  if test -e __argGitlabPath__; then
    git --no-pager diff --no-index __argGitlabPath__ __argGitlabCiYaml__
  else
    git --no-pager diff --no-index /dev/null __argGitlabPath__
  fi
}

function main {
  local up_to_date

  info Generating gitlab-ci.yaml @ __argGitlabPath__ \
    && if is_up_to_date; then up_to_date=true; else up_to_date=false; fi \
    && copy __argGitlabCiYaml__ __argGitlabPath__ \
    && if test "${up_to_date}" != true; then
      error __argGitlabPath__ was not up to date
    fi
}

main "${@}"
