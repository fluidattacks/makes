# shellcheck shell=bash

function main {
  local pip_install=(
    python -m pip install
    --cache-dir .
    --index-url "file://${PWD}/mirror"
    --no-deps
  )

  pypi-mirror create \
    --download-dir "${envDownloads}" \
    --mirror-dir mirror \
    && python -m venv "${out}" \
    && source "${out}/bin/activate" \
    && HOME=. "${pip_install[@]}" --upgrade pip \
    && HOME=. "${pip_install[@]}" --requirement "${envClosure}"
}

main "${@}"
