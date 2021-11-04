# shellcheck shell=bash

function kill_port {
  local pids
  local port="${1}"

  pids="$(mktemp)" \
    && if ! lsof -t "-i:${port}" > "${pids}"; then
      info Nothing listening on port: "${port}" \
        && return 0
    fi \
    && while read -r pid; do
      if kill -9 "${pid}"; then
        if timeout 5 tail --pid="${pid}" -f /dev/null; then
          info "Killed pid: ${pid}, listening on port: ${port}"
        else
          warn "kill timeout pid: ${pid}, listening on port: ${port}"
        fi
      else
        error "Unable to kill pid: ${pid}, listening on port: ${port}"
      fi
    done < "${pids}"
}

function done_port{
  local host='localhost'
  local port="${1}"

  kill_port "${port}" \
    && echo "[INFO] Done at ${host}:${port}" \
    && nc -kl "${host}" "${port}"
}
