# shellcheck shell=bash

function main {
  local location="${out}${envLocation}"

  echo '[INFO] Copying files' \
    && mkdir -p "$(dirname "${location}")" \
    && {
      cat "${envEntrypointSetup}" \
        && echo \
        && cat "${envEntrypoint}"
    } > "${location}" \
    && chmod +x "${location}"
}

main "${@}"
