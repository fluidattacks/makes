# shellcheck shell=bash

function main {
  source __argTargets__/template local targets
  local pattern=(
    "${targets[@]}"
    -name '*.yaml'
    -or
    -name '*.yml'
  )

  info "Formatting YAML files" \
    && if find "${pattern[@]}" -exec prettier --check --parser yaml {} \+; then
      return 0
    fi \
    && info "Some files do not comply the YAML format. We will format them but this job will fail." \
    && find "${pattern[@]}" -exec prettier --parser yaml --write {} \+

  return 1
}

main "${@}"
