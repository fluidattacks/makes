# shellcheck shell=bash

function main {
  source __argTargets__/template local targets

  info Formatting Nix code \
    && for target in "${targets[@]}"; do
      info Formatting "${target}" \
        && if ! nixfmt "${target}"; then
          info Source code was formated, the job will fail \
            && error Failing as promised...
        fi \
        || return 1
    done
}

main "${@}"
