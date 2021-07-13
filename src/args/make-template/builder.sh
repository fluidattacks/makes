# shellcheck shell=bash

export PATH="${__envPath}:${PATH:-}"

function replace_arg_in_file {
  local file="${1}"
  local arg_name="${2}"
  local arg_value="${3}"

  if grep --fixed-strings --quiet "${arg_name}" "${file}"; then
    rpl "${arg_name}" "${arg_value}" "${file}" 2> /dev/null
  else
    error Argument is not being used: "${arg_name}", please remove it
  fi
}

function main {
  mkdir "${out}" \
    && echo "${__envTemplate}" > "${out}/makes-setup.sh" \
    && while read -r 'var_name'; do
      replace_arg_in_file "${out}/makes-setup.sh" \
        "${var_name}" \
        "${!var_name}" \
        || return 1
    done < "${__envArgumentNamesFile}" \
    && while read -r 'var_name'; do
      replace_arg_in_file "${out}/makes-setup.sh" \
        "${var_name}" \
        "$(echo -n "${!var_name}" | base64 --wrap=0)" \
        || return 1
    done < "${__envArgumentBase64NamesFile}" \
    && if grep --perl-regexp "${__envArgumentsRegex}" "${out}/makes-setup.sh"; then
      error Some arguments are not being used
    fi
}

main "${@}"
