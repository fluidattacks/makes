# shellcheck shell=bash

function main {
  local args=(
    -refresh=true
  )

  cd "$(mktemp -d)" \
    && copy '__argSrc__' . \
    && info Initializing '__argSrc__' \
    && terraform init \
    && info Applying '__argSrc__' \
    && if running_in_ci_cd_provider; then
      args+=(-auto-approve)
    fi \
    && terraform apply "${args[@]}"
}

main "${@}"
