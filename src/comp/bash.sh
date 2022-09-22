# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function __comp_makes_bash {
  local opt
  local opts
  local temp
  export COMP_CWORD
  export COMP_WORDS
  export COMPREPLY=()

  opt="${COMP_WORDS[COMP_CWORD]}" \
    && case "${COMP_CWORD}" in
      1)
        temp="$(mktemp)" \
          && opts=(. github: github:owner/repo@rev gitlab: gitlab:owner/repo@rev) \
          && COMP_WORDBREAKS=" " compgen -W "${opts[*]}" -- "${opt}" > "${temp}" \
          && mapfile -t COMPREPLY < "${temp}"
        ;;
      2)
        temp="$(mktemp)" \
          && m "${COMP_WORDS[1]}" |& grep '^  /' > "${temp}" \
          && mapfile -t opts < "${temp}" \
          && COMP_WORDBREAKS=" " compgen -W "${opts[*]}" -- "${opt}" > "${temp}" \
          && mapfile -t COMPREPLY < "${temp}"
        ;;
      *) return 1 ;;
    esac
}

complete -F __comp_makes_bash m
