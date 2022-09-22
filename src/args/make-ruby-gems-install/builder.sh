# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  source "${envGemsSpec}/template" local gems_spec

  cd "${envGems}" \
    && gem install \
      --install-dir "${out}" \
      --local \
      --no-document \
      "${gems_spec[@]}" \
    && rm -rf "${out}/build_info" \
    && rm -rf "${out}/cache" \
    && patch_shebangs "${out}/bin"
}

main "${@}"
