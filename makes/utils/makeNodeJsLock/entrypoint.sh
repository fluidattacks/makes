# shellcheck shell=bash

function main {
  local node_js_version="${1}"
  local package_json="${2}"
  local npm_install_args=(
    --audit false
    --ignore-scripts true
  )
  local dir_package_json

  : && dir_package_json=$(dirname "${package_json}") \
    && case "${node_js_version}" in
      14) npm=__argNode14__/bin/npm ;;
      16) npm=__argNode16__/bin/npm ;;
      18) npm=__argNode18__/bin/npm ;;
      *) critical NodeJs version not supported: "${node_js_version}" ;;
    esac \
    && pushd "${dir_package_json}" \
    && "${npm}" install "${npm_install_args[@]}" \
    && popd || return 1
}

main "${@}"
