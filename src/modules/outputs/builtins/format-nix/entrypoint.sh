# shellcheck shell=bash

function main {
  local paths=__envTargets__

  info Formatting Nix code \
    && for path in "${paths[@]}"; do
      info Formatting "${path}" \
        && if ! nixpkgs-fmt --check "${path}" > /dev/null; then
          error "Source code is not formated" \
            && error "We will format it for you, but the job will fail" \
            && nixpkgs-fmt "${path}" \
            && return 1 \
            || return 1
        fi
    done
}

main "${@}"
