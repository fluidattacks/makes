# shellcheck shell=bash

function main {
  python -m venv "${out}" \
    && source "${out}/bin/activate" \
    && HOME=. python -m pip install \
      --cache-dir . \
      --index-url "file://${envMirror}/mirror" \
      --requirement "${envMirror}/deps.txt" \
      --requirement "${envMirror}/sub-deps.txt"
}

main "${@}"
