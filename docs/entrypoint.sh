# shellcheck shell=bash

function _deploy {
  local env="${1-}"
  local domain="makes.fluidattacks.tech"
  local cname_path="src/CNAME"

  rm -rf "${cname_path}"
  if [ "${env}" == "prod" ]; then
    echo "${domain}" > "${cname_path}"
  fi
  poetry run mkdocs gh-deploy --force --no-history
}

function _dev {
  poetry run mkdocs serve
}

function main {
  local dir="docs"

  pushd "${dir}" || error "${dir} directory not found"
  poetry install --no-root

  case "${1:-}" in
    deploy) _deploy "${@:2}" ;;
    dev) _dev "${@:2}" ;;
    *) error "Must provide either 'deploy', 'dev' as the first argument" ;;
  esac
}

main "${@}"
