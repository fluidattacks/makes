# shellcheck shell=bash

function main {
  local ruby_version="${1}"
  local deps_path="${2}"
  local lock_path="${3}"
  local ruby_path

  : && case "${ruby_version}" in
    3.1) ruby_path=__argRuby31__ ;;
    3.2) ruby_path=__argRuby32__ ;;
    3.3) ruby_path=__argRuby33__ ;;
    *) critical Ruby version not supported: "${ruby_version}" ;;
  esac \
    && info "Generating manifest:" \
    && pushd "$(mktemp -d)" \
    && "${ruby_path}/bin/ruby" \
      "__argParser__" \
      "${ruby_version}" \
      "${ruby_path}" \
      "${deps_path}" \
      > sources.json \
    && yj -yy < sources.json > "${lock_path}" \
    && popd \
    && info "Generated a lock file at ${lock_path}"
}

main "${@}"
