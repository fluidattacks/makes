# shellcheck shell=bash

source __argShellCommands__

function _kill_port {
  local pids
  local port="${1}"

  pids="$(mktemp)" \
    && if ! lsof -t "-i:${port}" > "${pids}"; then
      info "No process was found listening on port ${port}" \
        && return 0
    fi \
    && while read -r pid; do
      if kill -9 "${pid}"; then
        if timeout 5 tail --pid="${pid}" -f /dev/null; then
          info "Process listening on port ${port} with PID ${pid} was successfully killed"
        else
          warn "Timeout while attempting to kill process with PID ${pid} listening on port ${port}"
        fi
      else
        error "Unable to kill process with PID ${pid} listening on port ${port}"
      fi
    done < "${pids}"
}
function kill_port {
  for port in "${@}"; do
    _kill_port "${port}" \
      || return 1
  done
}

function done_port {
  local host="${1}"
  local port="${2}"

  kill_port "${port}" \
    && info "Done at ${host}:${port}" \
    && nc -kl "${host}" "${port}"
}

function wait_for_tcp {
  local elapsed=1
  local max_timeout=$(("${1}"))
  local host="${2%:*}"
  local port="${2#*:}"

  while true; do
    if timeout 1s nc -z "${host}" "${port}"; then
      return 0
    elif [ $elapsed -gt $max_timeout ]; then
      error "Timeout while waiting for ${host}:${port} to open" \
        && return 1
    else
      info "Waiting 1 second for ${host}:${port} to open: ${elapsed} seconds in total" \
        && sleep 1 \
        && ((elapsed++)) \
        && continue
    fi
  done
}

function wait_port {
  local pids=()
  local max_timeout="${1}"

  for address in "${@:2}"; do
    { wait_for_tcp "${max_timeout}" "${address}" & } \
      && pids+=("${!}")
  done \
    && for pid in "${pids[@]}"; do
      wait "${pid}" \
        || return 1
    done
}
