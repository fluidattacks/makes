# shellcheck shell=bash

function main {
  source __argMap__/makes-setup.sh map

  info Making environment variables for __argName__: \
    && for var in "${!map[@]}"; do
      info - "${var}=${map[${var}]}" \
        && export "${var}=${map[${var}]}" \
        || return 1
    done
}

main "${@}"
