# shellcheck shell=bash

function main {
  source __argMap__/template map

  info Making secret for Terraform from environment variables for __argName__: \
    && for var in "${!map[@]}"; do
      require_env_var "${map[${var}]}" \
        && info - "TF_VAR_${var}" \
        && export "TF_VAR_${var}=${!map[${var}]}" \
        || return 1
    done
}

main "${@}"
