# shellcheck shell=bash

function main {
  mkdocs serve -f docs/mkdocs.yml
}

main "${@}"
