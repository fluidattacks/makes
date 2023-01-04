# shellcheck shell=bash

# Compatibility layer with Nixpkgs' stdenv
export buildInputs="${__envNixpkgsBuildInputs}"
export initialPath="${__envNixpkgsInitialPath}"
source "${__envNixpkgsSrc}/pkgs/stdenv/generic/setup.sh"

function replace_arg_in_file {
  local file="${1}"
  local arg_name="${2}"
  local arg_value="${3}"

  if grep --fixed-strings --quiet "${arg_name}" "${file}"; then
    rpl --quiet --encoding UTF-8 -- "${arg_name}" "${arg_value}" "${file}" 2> /dev/null
  else
    error Argument is not being used: "${arg_name}", please remove it
  fi
}

function main {
  mkdir "${out}" \
    && echo "${__envTemplate}" > "${out}/template" \
    && while read -r 'var_name'; do
      replace_arg_in_file "${out}/template" \
        "${var_name}" \
        "${!var_name}" \
        || return 1
    done < "${__envArgumentNamesFile}" \
    && while read -r 'var_name'; do
      replace_arg_in_file "${out}/template" \
        "${var_name}" \
        "$(echo -n "${!var_name}" | base64 --wrap=0)" \
        || return 1
    done < "${__envArgumentBase64NamesFile}" \
    && if grep --perl-regexp "${__envArgumentsRegex}" "${out}/template"; then
      error Some arguments are not being used
    fi
}

main "${@}"
