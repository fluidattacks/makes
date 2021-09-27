# shellcheck shell=bash

function main {
  source __argExtraFlags__/template local extra_flags

  cd "$(mktemp -d)" \
    && copy __argSrc__ . \
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
