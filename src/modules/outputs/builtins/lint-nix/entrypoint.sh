# shellcheck shell=bash

function main {
  export LANG=C.UTF-8
  local paths=__envTargets__
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
    && for path in "${paths[@]}"; do
      info Linting "${path}" \
        && nix-linter "${args[@]}" "${path}" \
        || return 1
    done
}

main "${@}"
