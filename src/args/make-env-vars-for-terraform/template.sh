# shellcheck shell=bash

function main {
  source __argMap__/template map

  info Making environment variables for Terraform for __argName__: \
    && for var in "${!map[@]}"; do
      info - "TF_VAR_${var}=${map[${var}]}" \
        && export "TF_VAR_${var}=${map[${var}]}" \
        || return 1
    done
}

main "${@}"
