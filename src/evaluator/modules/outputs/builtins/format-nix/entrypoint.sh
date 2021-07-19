# shellcheck shell=bash

function main {
  source __argTargets__ local targets

  info Formatting Nix code \
    && for target in "${targets[@]}"; do
      info Formatting "${target}" \
        && if ! nixpkgs-fmt --check "${target}" > /dev/null; then
          info Source code is not formated \
            && info We will format it for you, but the job will fail \
            && nixpkgs-fmt "${target}" \
            && error Failing as promised...
        fi \
        || return 1
    done
}

main "${@}"
