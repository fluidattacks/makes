# shellcheck shell=bash

function main {
  local args=(
    -list=false
    -recursive
  )
  local paths=__argTargets__

  info Formatting terraform code \
    && if running_in_ci_cd_provider; then
      args+=(-check)
    fi \
    && for path in "${paths[@]}"; do
      terraform fmt "${args[@]}" "${path}"
    done
}

main "${@}"
