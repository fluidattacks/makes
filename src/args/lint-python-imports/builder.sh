# shellcheck shell=bash

function main {
  cd "${envSrc}" \
    && lint-imports --config "${envConfig}" \
    && touch "${out}"
}

main "${@}"
