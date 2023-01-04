# shellcheck shell=bash

function main {
  python "${envScriptCvss}" "${envTarget}" > "${out}"
}

main "${@}"
