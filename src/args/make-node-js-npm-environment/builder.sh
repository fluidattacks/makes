# shellcheck shell=bash

function main {
  local ephemeral
  local registry_address='127.0.0.1'
  local registry_port='10123'

  ephemeral="$(mktemp -d)" \
    && mkdir "${out}" \
    && cd "${out}" \
    && copy "${envPackageJson}" package.json \
    && copy "${envPackageLockJson}" package-lock.json \
    && {
      python -m http.server \
        --bind "${registry_address}" \
        --directory "${envRegistryMirror}" \
        "${registry_port}" &
    } \
    && HOME="${ephemeral}" npm install \
      --audit false \
      --registry "http://${registry_address}:${registry_port}"
}

main "${@}"
