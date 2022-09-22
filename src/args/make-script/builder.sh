# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  source "${envAliases}"/template local aliases

  info Copying files \
    && mkdir -p "${out}/bin" \
    && cd "${out}/bin" \
    && for location in "${aliases[@]}"; do
      cat "${envEntrypointSetup}/template" > "${location}" \
        && echo >> "${location}" \
        && cat "${envEntrypoint}/template" >> "${location}" \
        && chmod +x "${location}"
    done
}

main "${@}"
