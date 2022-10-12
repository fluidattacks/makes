# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck disable=SC2015 shell=bash
function plain_bin {
  local dependency_name="${1}"

  echo "${dependency_name}" \
    | tr "/" "-" \
    || return 1
}

function main {
  local ephemeral
  local registry_address='127.0.0.1'
  local registry_pid
  local registry_port
  local npm_install_args

  ephemeral="$(mktemp -d)" \
    && cd "${ephemeral}" \
    && copy "${envPackageJson}" package.json \
    && copy "${envPackageLockJson}" package-lock.json \
    && registry_port="$((10000 + "${RANDOM}" % 10000))" \
    && npm_install_args=(
      --audit false
      --registry "http://${registry_address}:${registry_port}"
    ) \
    && if test -n "${envShouldIgnoreScripts}"; then
      npm_install_args+=(--ignore-scripts true)
    fi \
    && {
      python -m http.server \
        --bind "${registry_address}" \
        --directory "${envRegistry}" \
        "${registry_port}" &
      registry_pid="${!}"
    } \
    && HOME="${ephemeral}" npm install "${npm_install_args[@]}" \
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
              && jq -r '.bin | to_entries[].key' < "${package_json}" > bins.lst \
              && jq -r '.bin | to_entries[].value' < "${package_json}" > bin_locations.lst \
              && mapfile -t bins < bins.lst \
              && mapfile -t bin_locations < bin_locations.lst \
              && for ((index = 0; index < "${#bins[@]}"; index++)); do
                : \
                  && bin="${bins[$index]}" \
                  && bin="$(plain_bin "${bin}")" \
                  && bin_location="${bin_locations[$index]}" \
                  && bin_location="$(dirname "${package_json}")/${bin_location}" \
                  && chmod +x "${bin_location}" \
                  && patch_shebangs "${bin_location}" \
                  && rm -rf "${out}/.bin/${bin}" \
                  && ln -s "${bin_location}" "${out}/.bin/${bin}" \
                  || return 1
              done
            ;;
          string)
            info Generating binaries from "${package_json}" \
              && bin="$(jq -er .name < "${package_json}")" \
              && bin="$(plain_bin "${bin}")" \
              && bin_location="$(jq -er .bin < "${package_json}")" \
              && bin_location="$(dirname "${package_json}")/${bin_location}" \
              && patch_shebangs "${bin_location}" \
              && rm -rf "${out}/.bin/${bin}" \
              && ln -s "${bin_location}" "${out}/.bin/${bin}"
            ;;
        esac \
        || return 1
    done \
    || kill "${registry_pid}"
}

main "${@}"
