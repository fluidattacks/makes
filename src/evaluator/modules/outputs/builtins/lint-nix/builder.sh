# shellcheck shell=bash

function main {
  export LANG=C.UTF-8
  source "${envTargets}" local targets
  local args=(
    --recursive
    --check=BetaReduction
    --check=EmptyVariadicParamSet
    --check=UnneededAntiquote
  )
  # Maybe these two are buggy, worth checking out in the future
  #   AlphabeticalArgs
  #   AlphabeticalBindings

  info Linting Nix code \
    && for target in "${targets[@]}"; do
      info Linting "${target}" \
        && nix-linter "${args[@]}" "${target}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
