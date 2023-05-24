# shellcheck shell=bash

function main {
  local args=(
    --dangerfile __argDangerfile__
    __argExtraArgs__
    "${@}"
  )

  : \
    && if test -n "${CI-}"; then
      danger ci "${args[@]}"
    else
      danger pr "${args[@]}"
    fi
}

main "${@}"
