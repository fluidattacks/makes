# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  source __argVars__/template local vars

  info Making secrets for env from sops for __argName__: \
    && decrypted="$(sops --decrypt --output-type json '__argManifest__')" \
    && for var in "${vars[@]}"; do
      info - "${var}" \
        && export "${var//./__}=$(echo "${decrypted}" | jq -erc ".${var}")" \
        || return 1
    done
}

main "${@}"
