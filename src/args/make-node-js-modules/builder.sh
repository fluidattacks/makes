# shellcheck disable=SC2015 shell=bash

function patch_shebang {
  local path="${1}"
  local regex='#! /usr/bin/env node'
  local replace

  replace="#! $(which node)" \
    && sed -i "s|${regex}|${replace}|" "${path}"
}

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
    && find "${out}" -name package.json -maxdepth 3 | sort > package_jsons.lst \
    && mapfile -t package_jsons < package_jsons.lst \
    && mkdir -p "${out}/.bin" \
    && for package_json in "${package_jsons[@]}"; do
      bin_type="$(jq -er '.bin|type' < "${package_json}")" \
        && case "${bin_type}" in
          object)
            info Generating binaries from "${package_json}" \
              && jq -er '.bin | to_entries[].key' < "${package_json}" > bins.lst \
              && jq -er '.bin | to_entries[].value' < "${package_json}" > bin_locations.lst \
              && mapfile -t bins < bins.lst \
              && mapfile -t bin_locations < bin_locations.lst \
              && for ((index = 0; index < "${#bins[@]}"; index++)); do
                : \
                  && bin="${bins[$index]}" \
                  && bin_location="${bin_locations[$index]}" \
                  && bin_location="$(dirname "${package_json}")/${bin_location}" \
                  && chmod +x "${bin_location}" \
                  && patch_shebang "${bin_location}" \
                  && rm -rf "${out}/.bin/${bin}" \
                  && ln -s "${bin_location}" "${out}/.bin/${bin}" \
                  || return 1
              done
            ;;
          string)
            info Generating binaries from "${package_json}" \
              && bin="$(jq -er .name < "${package_json}")" \
              && bin_location="$(jq -er .bin < "${package_json}")" \
              && bin_location="$(dirname "${package_json}")/${bin_location}" \
              && rm -rf "${out}/.bin/${bin}" \
              && ln -s "${bin_location}" "${out}/.bin/${bin}"
            ;;
        esac \
        || return 1
    done \
    || kill "${registry_pid}"
}

main "${@}"
