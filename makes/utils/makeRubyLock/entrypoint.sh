# shellcheck shell=bash

function main {
  local ruby_version="${1}"
  local deps_path="${2}"
  local lock_path="${3}"
  local ruby

  : \
    && case "${ruby_version}" in
      2.7) ruby=__argRuby27__ ;;
      3.0) ruby=__argRuby30__ ;;
      3.1) ruby=__argRuby31__ ;;
      *) critical Ruby version not supported: "${ruby_version}" ;;
    esac \
    && info "Generating manifest:" \
    && pushd "$(mktemp -d)" \
    && "__argRuby27__/bin/ruby" \
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
