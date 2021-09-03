# shellcheck disable=SC2015 shell=bash

function main {
  local ephemeral
  local registry_address='127.0.0.1'
  local registry_pid
  local registry_port

  ephemeral="$(mktemp -d)" \
    && cd "${ephemeral}" \
    && copy "${envPackageJson}" package.json \
    && copy "${envPackageLockJson}" package-lock.json \
    && registry_port="$((10000 + "${RANDOM}" % 10000))" \
    && {
      python -m http.server \
        --bind "${registry_address}" \
        --directory "${envRegistry}" \
        "${registry_port}" &
      registry_pid="${!}"
    } \
    && HOME="${ephemeral}" npm install \
      --audit false \
      --registry "http://${registry_address}:${registry_port}" \
    && kill "${registry_pid}" \
    && mv "${ephemeral}/node_modules" "${out}" \
    || kill "${registry_pid}"
}

main "${@}"
