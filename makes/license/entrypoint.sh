# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local license=(
    reuse addheader
    --copyright 'Fluid Attacks and Makes contributors'
    --license MIT
  )
  declare -A languages=(
    [cfg]=python
    [hcl]=python
    [js]=c
    [md]=html
    [nix]=python
    [py]=python
    [rb]=python
    [sh]=python
    [tf]=python
    [toml]=python
  )

  : \
    && license+=(
      --year="$(date +%Y)"
    ) \
    && if reuse lint; then
      return 0
    fi \
    && for extension in "${!languages[@]}"; do
      find . -type f -name "*.${extension}" \
        -exec "${license[@]}" --style="${languages[$extension]}" {} \+
    done \
    && remaining=(! -wholename '*/.git/*') \
    && for extension in "${!languages[@]}"; do
      remaining+=(! -name "*.${extension}")
    done \
    && find . "${remaining[@]}" -type f \
      -exec "${license[@]}" --explicit-license {} \+ \
    && critical "Some files are missing licensing information. When this command fails it adds the propper licensing notices to the files that need it, please commit those changes."
}

main "${@}"
