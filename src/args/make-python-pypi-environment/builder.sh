# shellcheck shell=bash

function main {
  pypi-mirror create \
    --download-dir "${envDownloads}" \
    --mirror-dir mirror \
    && python -m venv "${out}" \
    && source "${out}/bin/activate" \
    && HOME=. python -m pip install \
      --cache-dir . \
      --index-url "file://${PWD}/mirror" \
      --no-deps \
      --requirement "${envClosure}"
}

main "${@}"
