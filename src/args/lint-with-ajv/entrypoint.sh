# shellcheck shell=bash

function main {
  source "__argTargets__/template" local targets

  pushd "__argAjvPath__" \
    && npm ci \
    && export PATH="${PWD}/node_modules/.bin:${PATH}" \
    && popd \
    && info "Compiling schema: __argSchema__" \
    && ajv compile -s "__argSchema__" \
    && for target in "${targets[@]}"; do
      info "Linting data: ${target}" \
        && ajv validate -s "__argSchema__" -d "${target}" \
        || return 1
    done
}

main "${@}"
