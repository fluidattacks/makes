# shellcheck shell=bash

function main {
  export LANG=C.UTF-8
  source "${envTargets}/template" local targets

  info Linting Nix code \
    && for target in "${targets[@]}"; do
      info Linting "${target}" \
        && statix check "${args[@]}" "${target}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
