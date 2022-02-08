# shellcheck shell=bash

function main {
  local node_js_version="${1}"
  local package_json="${2}"
  local package_lock="${3}"

  case "${node_js_version}" in
    10) npm=__argNode10__/npm ;;
    12) npm=__argNode12__/npm ;;
    14) npm=__argNode14__/npm ;;
    16) npm=__argNode16__/npm ;;
    *) critical NodeJs version not supported: "${node_js_version}" ;;
  esac \
    && pushd "$(mktemp -d)" \
    && copy "${package_json}" package.json \
    && npm_install_args=(
      --audit false
      --ignore-scripts true
    ) \
    && "${npm}" install "${npm_install_args[@]}" \
    && copy package-lock.json "${package_lock}" \
    && popd || return 1
}

main "${@}"
