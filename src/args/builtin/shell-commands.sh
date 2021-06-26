# shellcheck shell=bash

function debug {
  echo "[DEBUG] ${*}"
}

function info {
  echo "[INFO] ${*}"
}

function warn {
  echo "[WARNING] ${*}"
}

function error {
  echo "[ERROR] ${*}"
}

function critical {
  echo "[CRITICAL] ${*}" \
    && exit 1 \
    || exit 1
}

function copy {
  cp --no-target-directory --recursive "${@}" \
    && chmod --recursive +w "${@: -1}"
}
