# shellcheck shell=bash

function main {
  local args=(
    -list=false
    -recursive
  )
  source __argTargets__/template local targets

  info Formatting terraform code \
    && if running_in_ci_cd_provider; then
      args+=(-check)
    fi \
    && for target in "${targets[@]}"; do
      terraform fmt "${args[@]}" "${target}"
    done
}

main "${@}"
