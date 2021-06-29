# shellcheck shell=bash

function main {
  local args=(
    -bn  # Binary operators at the begining of line
    -ci  # Indent switch cases
    -i 2 # Indent 2 spaces
    -s   # Simplifies code
    -sr  # Space after redirect operators
    -w   # Format in-place
  )
  local paths=__envTargets__

  info Formatting bash code \
    && if test -n "${CI:-}"; then
      args+=(-d)
    fi \
    && for path in "${paths[@]}"; do
      shfmt "${args[@]}" "${path}"
    done
}

main "${@}"
