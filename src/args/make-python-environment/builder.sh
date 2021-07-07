# shellcheck shell=bash

function main {
  local pip=(python -m pip --cache-dir .)

  info Creating virtualenv \
    && python -m venv "${out}" \
    && info Activating virtualenv \
    && source "${out}/bin/activate" \
    && info Installing \
    && HOME=. "${pip[@]}" install --requirement "${envRequirementsFile}" \
    && info Freezing \
    && HOME=. "${pip[@]}" freeze | sort --ignore-case > "${out}/installed" \
    && sed -E 's|^(.*)\[.*?\](.*)$|\1\2|g' "${envRequirementsFile}" > "${out}/desired" \
    && if test "$(cat "${out}/desired")" = "$(cat "${out}/installed")"; then
      info Integrity check passed
    else
      info Integrity check failed \
        && info You need to specify all dependencies: \
        && git --no-pager diff --no-index "${out}/desired" "${out}/installed" \
        && error Stopping due to failed integrity check
    fi \
    && rm -f "${out}/desired" \
    && rm -f "${out}/installed"
}

main "${@}"
