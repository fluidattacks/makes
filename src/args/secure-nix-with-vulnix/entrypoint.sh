# shellcheck shell=bash

function main {
  export HOME="${HOME_IMPURE}"
  source __argDerivations__/template local derivations

  for derivation in "${derivations[@]}"; do
    vulnix --whitelist __argWhitelist__ "${derivation}" \
      || critical We found vulnerabilities in "${derivation}"
  done
}

main "${@}"
