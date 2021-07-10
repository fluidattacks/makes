# shellcheck shell=bash

function main {
  local paths

  info Linting Markdown code \
    && eval paths="${envTargets}" \
    && for path in "${paths[@]}"; do
      info Linting "${path}" \
        && mdl --style "${envStyle}" "${path}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
