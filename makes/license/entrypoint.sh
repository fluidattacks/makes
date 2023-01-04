# shellcheck shell=bash

function main {
  if ! reuse lint; then
    error "Some files are not properly licensed. Please adapt .reuse/dep5"
  fi
}

main "${@}"
