# shellcheck shell=bash

function main {
  source "${envAliases}"/template local aliases

  info Copying files \
    && mkdir -p "${out}/bin" \
    && cd "${out}/bin" \
    && for location in "${aliases[@]}"; do
      cat "${envEntrypointSetup}/template" > "${location}" \
        && echo >> "${location}" \
        && cat "${envEntrypoint}/template" >> "${location}" \
        && chmod +x "${location}" # NOFLUID Intended Behavior
    done
}

main "${@}"
