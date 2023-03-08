# shellcheck shell=bash

function main {
  mkdocs build -f docs/mkdocs.yml
}

main "${@}"
