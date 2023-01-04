# shellcheck shell=bash

function main {
  local key="${1}"
  local output="${2}"

  sops --encrypt --kms "${key}" "__argTemplate__" > "${output}"
}

main "${@}"
