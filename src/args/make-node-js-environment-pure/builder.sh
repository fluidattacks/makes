# shellcheck shell=bash

function main {
  local ephemeral

  ephemeral="$(mktemp -d)" \
    && mkdir "${out}" \
    && cd "${out}" \
    && jq -er < "${envPackageLockJson}" \
    && copy "${envPackageLockJson}" package-lock.json \
    && HOME="${ephemeral}" npm install
}

main "${@}"
