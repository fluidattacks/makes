# shellcheck shell=bash

function main {
  python -m venv venv \
    && source venv/bin/activate \
    && pip download \
      --abi none \
      --cache-dir . \
      --dest downloads \
      --disable-pip-version-check \
      --implementation py \
      --no-python-version-warning \
      --only-binary=:all: \
      --platform any \
      --pre \
      --progress-bar ascii \
      --requirement "${envDeps}" \
      --requirement "${envSubDeps}" \
    && pypi-mirror create \
      --copy \
      --download-dir downloads \
      --mirror-dir "${out}/mirror" \
    && copy "${envDeps}" "${out}/deps.txt" \
    && copy "${envSubDeps}" "${out}/sub-deps.txt" \
    && python "${envCheckCompleteness}" \
      "${out}/mirror" "${envDeps}" "${envSubDeps}"
}

main "${@}"
