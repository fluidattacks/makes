# shellcheck shell=bash

function main {
  local env="${1-}"
  local domain="makes.fluidattacks.tech"
  local cname_path="src/CNAME"

  : \
    && pushd docs \
    && rm -rf "${cname_path}" \
    && if [ "${env}" == "prod" ]; then
      echo "${domain}" > "${cname_path}"
    fi \
    && mkdocs gh-deploy --force --no-history
}

main "${@}"
