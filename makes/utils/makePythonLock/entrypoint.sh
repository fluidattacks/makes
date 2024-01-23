# shellcheck shell=bash

function main {
  local python_version="${1}"
  local project="${2}"

  : && if ! ls "${project}/pyproject.toml" &> /dev/null; then
    error "Provided route must contain a pyproject.toml file"
  fi \
    && info "Generating poetry.lock" \
    && cd "$(mktemp -d)" \
    && cp "${project}/pyproject.toml" . \
    && poetry env use "${python_version}" \
    && poetry lock \
    && cp "poetry.lock" "${project}/poetry.lock"
}

main "${@}"
