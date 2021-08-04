# shellcheck shell=bash

function main {
  local args=(
    -lock=false
    -refresh=true
  )
  export TF_LOG

  cd "$(mktemp -d)" \
    && copy '__argSrc__' . \
    && info Initializing '__argSrc__' \
    && terraform init \
    && info Testing '__argSrc__' \
    && if test -n '__argDebug__'; then
      TF_LOG=TRACE \
        && args+=(
          -parallelism=1
        )
    fi \
    && terraform plan "${args[@]}"
}

main "${@}"
