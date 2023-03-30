# shellcheck shell=bash

function echo_stderr {
  echo "${@}" 1>&2
}

function debug {
  echo_stderr "[DEBUG]" "${@}"
}

function info {
  echo_stderr "[INFO]" "${@}"
}

function warn {
  echo_stderr "[WARNING]" "${@}"
}

function error {
  echo_stderr "[ERROR]" "${@}" \
    && return 1
}

function critical {
  echo_stderr "[CRITICAL]" "${@}" \
    && exit 1
}

function copy {
  cp --no-target-directory --recursive "${@}" \
    && chmod --recursive +w "${@: -1}"
}

function require_env_var {
  local var_name="${1}"

  if test -z "${!var_name-}"; then
    critical Env var is required but is empty or not present: "${var_name}"
  fi
}
