# shellcheck shell=bash

function main {
  source __argTargets__/template local targets
  local args=()

  info Formatting Nix code \
    && if running_in_ci_cd_provider; then
      args+=(--check)
    fi \
    && for target in "${targets[@]}"; do
      info Formatting "${target}" \
        && if ! nixfmt "${args[@]}" "${target}"; then
          info Source code was formated, the job will fail \
            && error Failing as promised...
        fi \
        || return 1
    done
}

main "${@}"
