# shellcheck shell=bash

function main {
  export LANG=C.UTF-8
  source __argTargets__/template local targets

  info Linting Nix code \
    && for target in "${targets[@]}"; do
      info Linting "${target}" \
        && if ! statix check "${args[@]}" "${target}"; then
          info Source code is being fixed, the job will fail \
            && statix fix "${args[@]}" "${target}" \
            && error Failing as promissed...
        fi \
        || return 1
    done
}

main "${@}"
