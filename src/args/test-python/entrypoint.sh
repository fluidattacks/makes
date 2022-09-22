# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  source __argExtraFlags__/template local extra_flags
  source __argExtraSrcs__/template extra_srcs

  cd "$(mktemp -d)" \
    && copy __argProject__ __project__ \
    && for extra_src in "${!extra_srcs[@]}"; do
      copy "${extra_srcs[$extra_src]}" "${extra_src}"
    done \
    && cd __project____argSrc__ \
    && pytest \
      --capture tee-sys \
      --disable-pytest-warnings \
      --durations 10 \
      --exitfirst \
      --showlocals \
      --show-capture no \
      -vvv \
      "${extra_flags[@]}"
}

main "${@}"
