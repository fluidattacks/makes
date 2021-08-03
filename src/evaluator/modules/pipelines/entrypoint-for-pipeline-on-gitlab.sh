# shellcheck shell=bash

function main {
  info Generating gitlab-ci.yaml @ __argGitlabPath__ \
    && copy __argGitlabCiYaml__ __argGitlabPath__ \
    && cat __argGitlabPath__
}

main "${@}"
