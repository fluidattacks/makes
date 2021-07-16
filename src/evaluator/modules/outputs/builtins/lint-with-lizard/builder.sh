# shellcheck shell=bash

function main {
  local paths
  local lizard_max_warns='0'
  local lizard_max_func_length='50'
  local lizard_max_ccn='10'
  local args=(
    --ignore_warnings "${lizard_max_warns}"
    --length "${lizard_max_func_length}"
    --CCN "${lizard_max_ccn}"
  )

  info Linting with Lizard \
    && eval paths="${envTargets}" \
    && for path in "${paths[@]}"; do
      info Linting "${path}" \
        && lizard "${args[@]}" "${path}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
