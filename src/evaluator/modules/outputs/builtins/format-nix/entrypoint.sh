# shellcheck shell=bash

function main {
  local paths=__argTargets__

  info Formatting Nix code \
    && for path in "${paths[@]}"; do
      info Formatting "${path}" \
        && if ! nixpkgs-fmt --check "${path}" > /dev/null; then
          info Source code is not formated \
            && info We will format it for you, but the job will fail \
            && nixpkgs-fmt "${path}" \
            && error Failing as promised...
        fi \
        || return 1
    done
}

main "${@}"
