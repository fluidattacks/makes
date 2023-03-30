#! __argShell__

# shellcheck shell=bash

source __argShellOptions__

function running_in_ci_cd_provider {
  # Non-empty on Gitlab, Github, Travis
  export CI

  test -n "${CI-}"
}

function prompt_user_for_confirmation {
  local answer

  warn Please type '"CONFIRM"' to continue: \
    && if running_in_ci_cd_provider; then
      info Running on CI/CD provider, assuming you would have confirmed
    else
      read -ep '>>> ' -r answer \
        && if test "${answer}" != 'CONFIRM'; then
          critical Only CONFIRM will be accepted as an answer, aborting
        fi
    fi
}

function prompt_user_for_input {
  local answer
  local default="${1}"

  info Please type your input or press enter to use: "${default}", as response \
    && if running_in_ci_cd_provider; then
      info Running on CI/CD provider, \
        assuming you would have chosen: "${default}"
    else
      read -ep '>>> ' -r answer \
        && if test -n "${answer}"; then
          echo "${answer}"
        else
          echo "${default}"
        fi
    fi
}

function setup {
  export HOME
  export HOME_IMPURE
  export SSL_CERT_FILE='__argCaCert__/etc/ssl/certs/ca-bundle.crt'
  export STATE

  source __argSearchPathsEmpty__/template \
    && source __argSearchPathsBase__/template \
    && if test -z "${HOME_IMPURE-}"; then
      HOME_IMPURE="${HOME-}" \
        && HOME="$(mktemp -d)"
    fi \
    && if test __argGlobalState__ -eq "0"; then
      STATE="__argProjectStateDir__/__argName__"
    else
      STATE="__argGlobalStateDir__/__argName__"
    fi \
    && if test __argPersistState__ -eq "0"; then
      rm -rf "${STATE}"
    fi \
    && mkdir -p "${STATE}" \
    && source __argShellCommands__ \
    && source __argSearchPaths__/template
}

setup
