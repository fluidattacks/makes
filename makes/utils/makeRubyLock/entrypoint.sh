# shellcheck shell=bash

function main {
  local ruby_version="${1}"
  local deps_path="${2}"
  local lock_path="${3}"
  local ruby

  : \
    && case "${ruby_version}" in
      3.1) ruby=__argRuby31__/bin/ruby ;;
      3.2) ruby=__argRuby32__/bin/ruby ;;
      3.3) ruby=__argRuby33__/bin/ruby ;;
      *) critical Ruby version not supported: "${ruby_version}" ;;
    esac \
    && info "Generating manifest:" \
    && pushd "$(mktemp -d)" \
    && "${ruby}" \
      "__argParser__" \
      "${ruby_version}" \
      "${ruby}" \
      "${deps_path}" \
      > sources.json \
    && yj -yy < sources.json > "${lock_path}" \
    && popd \
    && info "Generated a lock file at ${lock_path}"
}

main "${@}"
