# shellcheck shell=bash

function main {
  local pip=(
    python -m pip
  )
  local pip_install=(
    "${pip[@]}" install
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
    && HOME=. "${pip_install[@]}" --requirement "${envClosure}" \
    && HOME=. "${pip[@]}" uninstall -y pip
}

main "${@}"
