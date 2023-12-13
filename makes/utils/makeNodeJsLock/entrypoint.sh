# shellcheck shell=bash

function main {
  local node_js_version="${1}"
  local package_json_dir="${2}"
  local npm_install_args=(
    --audit false
    --ignore-scripts true
  )

  : && case "${node_js_version}" in
      14) npm=__argNode14__/bin/npm ;;
      16) npm=__argNode16__/bin/npm ;;
      18) npm=__argNode18__/bin/npm ;;
      *) critical NodeJs version not supported: "${node_js_version}" ;;
    esac \
    && pushd "${package_json_dir}" \
    && "${npm}" install "${npm_install_args[@]}" \
    && popd || return 1
}

main "${@}"
