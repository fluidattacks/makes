# shellcheck shell=bash

function main {
  local location="${out}${envLocation}"

  info Copying files \
    && mkdir -p "$(dirname "${location}")" \
    && {
      cat "${envEntrypointSetup}" \
        && echo \
        && cat "${envEntrypoint}"
    } > "${location}" \
    && chmod +x "${location}"
}

main "${@}"
