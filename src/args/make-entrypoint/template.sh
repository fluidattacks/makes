#! __envShell__
# shellcheck shell=bash

source __envBuiltinShellOptions__

function setup {
  export CLASSPATH='/not-set'
  export GEM_PATH='/not-set'
  export HOME
  export HOME_IMPURE
  export LD_LIBRARY_PATH='/not-set'
  export MYPYPATH='/not-set'
  export NODE_PATH='/not-set'
  export PATH='/not-set'
  export PYTHONPATH='/not-set'
  export SSL_CERT_FILE='__envCaCert__/etc/ssl/certs/ca-bundle.crt'
  export STATE=~/.makes/state/'__envName__'

  source __envSearchPathsBase__ \
    && rm -rf "${STATE}" \
    && mkdir -p "${STATE}" \
    && if test -z "${HOME_IMPURE:-}"; then
      HOME_IMPURE="${HOME:-}" \
        && HOME="$(mktemp -d)"
    fi \
    && source __envBuiltinShellCommands__ \
    && source __envSearchPaths__
}

setup
