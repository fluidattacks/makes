# shellcheck shell=bash

function main {
  yq . "${envSrc}" > "${out}"
}

main "${@}"
