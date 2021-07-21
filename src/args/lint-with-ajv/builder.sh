# shellcheck shell=bash

function main {
  source "${envTargets}" local targets

  info "Compiling schema: ${envSchema}" \
    && ajv compile -s "${envSchema}" \
    && for target in "${targets[@]}"; do
      info "Linting data: ${target}" \
        && ajv validate -s "${envSchema}" -d "${target}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
