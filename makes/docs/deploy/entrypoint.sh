# shellcheck shell=bash

function main {
  local env="${1:-}"
  local domain="makes.fluidattacks.com"
  local cname_path="src/CNAME"
  local args=(
    gh-deploy
    --force
    --no-history
  )

  : \
    && pushd docs \
    && rm -rf "${cname_path}" \
    && if [ "${env}" == "prod" ]; then
      : \
        && echo "${domain}" > "${cname_path}" \
        && args+=(
          --github-remote
          "https://${GITHUB_TOKEN}@github.com/fluidattacks/makes.git"
        )
    fi \
    && mkdocs "${args[@]}"
}

main "${@}"
