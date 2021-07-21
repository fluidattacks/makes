# shellcheck shell=bash

function main {
  bandit --recursive "${envTarget}" \
    && touch "${out}"
}

main "${@}"
