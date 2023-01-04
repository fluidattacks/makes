# shellcheck shell=bash

function main {
  source __argTargets__/template local targets

  for target in "${targets[@]}"; do
    '__argScalaFmtBinary__' "${target}"
  done
}

main "${@}"
