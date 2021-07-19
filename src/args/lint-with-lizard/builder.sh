# shellcheck shell=bash

function main {
  local lizard_max_warns='0'
  local lizard_max_func_length='50'
  local lizard_max_ccn='10'
  source "${envTargets}" local targets
  local args=(
    --ignore_warnings "${lizard_max_warns}"
    --length "${lizard_max_func_length}"
    --CCN "${lizard_max_ccn}"
  )

  info Linting with Lizard \
    && lizard "${args[@]}" "${targets[@]}" \
    && touch "${out}"
}

main "${@}"
