# shellcheck shell=bash

function main {
  info Copying files \
    && mkdir -p "${out}/bin" \
    && cd "${out}/bin" \
    && eval local aliases="${envAliases}" \
    && for location in "${aliases[@]}"; do
      cat "${envEntrypointSetup}" > "${location}" \
        && echo > "${location}" \
        && cat "${envEntrypoint}" > "${location}" \
        && chmod +x "${location}"
    done
}

main "${@}"
