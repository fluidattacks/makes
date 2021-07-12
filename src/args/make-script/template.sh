#! __argShell__
# shellcheck shell=bash

source __argBuiltinShellOptions__

function running_in_ci_cd_provider {
  # Non-empty on Gitlab, Github, Travis
  export CI

  test -n "${CI:-}"
}

function setup {
  export HOME
  export HOME_IMPURE
  export SSL_CERT_FILE='__argCaCert__/etc/ssl/certs/ca-bundle.crt'
  export STATE=~/.makes/state/'__argName__'

  source __argSearchPathsEmpty__ \
    && source __argSearchPathsBase__ \
    && rm -rf "${STATE}" \
    && mkdir -p "${STATE}" \
    && if test -z "${HOME_IMPURE:-}"; then
      HOME_IMPURE="${HOME:-}" \
        && HOME="$(mktemp -d)"
    fi \
    && source __argBuiltinShellCommands__ \
    && source __argSearchPaths__
}

setup
