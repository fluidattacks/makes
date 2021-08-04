# shellcheck shell=bash

function main {
  local src=__argSrc__
  source __argResources__ local resources

  cd "$(mktemp -d)" \
    && copy "${src}" . \
    && info Initializing "${src}" \
    && terraform init \
    && info Refreshing state "${src}" \
    && terraform refresh \
    && for resource in "${resources[@]}"; do
      info Tainting "${src}" @ "${resource}" \
        && terraform taint "${resource}" \
        || return 1
    done
}

main "${@}"
