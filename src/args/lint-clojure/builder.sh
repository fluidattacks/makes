# shellcheck shell=bash

function main {
  local args=(
    --lint
  )

  info Linting Clojure solution \
    && clj-kondo "${args[@]}" "${envTarget}" \
    && touch "${out}"
}

main "${@}"
