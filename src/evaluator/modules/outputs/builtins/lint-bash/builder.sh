# shellcheck shell=bash

function main {
  local tmp
  local paths
  local args=(
    "--exclude=SC1090,SC1091,SC2016,SC2153,SC2154"
    "--external-sources"
  )
  # SC1090: Can't follow non-constant source. Use a directive to specify location.
  # SC1091: Not following: x: openBinaryFile: does not exist (No such file or directory)
  # SC2016: Expressions don't expand in single quotes, use double quotes for that.
  # SC2153: Possible misspelling: x may not be assigned, but y is.
  # SC2154: x is referenced but not assigned.

  info Linting bash code \
    && eval paths="${envTargets}" \
    && tmp="$(mktemp)" \
    && for path in "${paths[@]}"; do
      find "${path}" -wholename '*.sh' -type f | sort --ignore-case > "${tmp}" \
        && while read -r path; do
          info Linting "${path}" \
            && shellcheck "${args[@]}" "${path}" \
            || return 1
        done < "${tmp}" \
        || return 1
    done \
    && touch "${out}"
}

main "${@}"
