# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  export LANG=C.UTF-8
  source "${envTargets}/template" local targets
  local args=(
    # --check=AlphabeticalArgs
    # --check=AlphabeticalBindings
    --check=BetaReduction
    --check=DIYInherit
    --check=EmptyVariadicParamSet
    --check=EmptyInherit
    --check=EmptyLet
    --check=EtaReduce
    --check=FreeLetInFunc
    --check=LetInInheritRecset
    --check=ListLiteralConcat
    --check=NegateAtom
    --check=SequentialLet
    --check=SetLiteralUpdate
    --check=UnfortunateArgName
    --check=UnneededAntiquote
    --check=UnneededRec
    --check=UnusedArg
    --check=UnusedLetBind
    --check=UpdateEmptySet
    --recursive
  )

  info Linting Nix code \
    && for target in "${targets[@]}"; do
      info Linting "${target}" \
        && nix-linter "${args[@]}" "${target}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
