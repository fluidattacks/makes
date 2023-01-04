# shellcheck shell=bash

function main {
  local args=(
    -lock=false
    -refresh=true
  )
  local src='__argSrc__'
  export TF_LOG

  pushd "${src}" \
    && info Initializing "${src}" \
    && terraform init \
    && info Testing "${src}" \
    && if test -n '__argDebug__'; then
      TF_LOG=TRACE \
        && args+=(
          -parallelism=1
        )
    fi \
    && terraform plan "${args[@]}"
}

main "${@}"
