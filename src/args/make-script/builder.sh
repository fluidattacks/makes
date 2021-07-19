# shellcheck shell=bash

function main {
  source "${envAliases}" local aliases

  info Copying files \
    && mkdir -p "${out}/bin" \
    && cd "${out}/bin" \
    && for location in "${aliases[@]}"; do
      cat "${envEntrypointSetup}/makes-setup.sh" > "${location}" \
        && echo >> "${location}" \
        && cat "${envEntrypoint}/makes-setup.sh" >> "${location}" \
        && chmod +x "${location}"
    done
}

main "${@}"
