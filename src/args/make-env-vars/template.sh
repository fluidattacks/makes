# shellcheck shell=bash

function main {
  source __argMap__/makes-setup.sh map
  for var in "${!map[@]}"; do
    export "${var}=${map[${var}]}" \
      || return 1
  done
}

main "${@}"
