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
  source __argTargets__/template local targets

  info Formatting bash code \
    && if running_in_ci_cd_provider; then
      args+=(-d)
    fi \
    && for target in "${targets[@]}"; do
      shfmt "${args[@]}" "${target}"
    done
}

main "${@}"
