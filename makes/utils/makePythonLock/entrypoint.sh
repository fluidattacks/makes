# shellcheck shell=bash

function main {
  local project="${1}"

  : && if ! ls "${project}/pyproject.toml" &> /dev/null; then
    error "Provided route must contain a pyproject.toml file"
  fi \
    && info "Generating poetry.lock" \
    && cd "$(mktemp -d)" \
    && cp "${project}/pyproject.toml" . \
    && poetry lock \
    && cp "poetry.lock" "${project}/poetry.lock"
}

main "${@}"
