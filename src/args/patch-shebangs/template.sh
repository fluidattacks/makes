# shellcheck shell=bash

# Simplified version of:
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/patch-shebangs.sh

function _patch_shebang {
  find -L "${1}" -type f -perm -0100 | while read -r path; do
    : \
      && read -r shebang < "${path}" \
      && read -r interpreter arg0 args <<< "${shebang:2}" \
      && case "${interpreter}" in
        */bin/env)
          case "${arg0}" in
            -* | *=*) error Couldnt patch "${path}": "${shebang}" ;;
            *) shebang="$(command -v "${arg0}")" ;;
          esac
          ;;
        *) shebang="$(command -v "$(basename "${interpreter}")") ${arg0} ${args}" ;;
      esac \
      && sed -i -e "1 s|.*|#\! ${shebang//\\/\\\\}|" "${path}"
  done
}

function patch_shebangs {
  for path in "${@}"; do
    if test -e "${path}"; then
      _patch_shebang "${path}" || continue
    fi
  done
}
