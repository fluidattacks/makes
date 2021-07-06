# shellcheck shell=bash

export PATH="${__envPath}:${PATH:-}"

function replace_var_in_file {
  local file="${1}"
  local var_name="${2}"
  local var_value="${3}"
  local var_name_tpl="__${var_name}__"

  if grep --fixed-strings --quiet "${var_name_tpl}" "${file}"; then
    sed -i "s|${var_name_tpl}|${var_value}|g" "${file}"
  else
    error Argument is not being used: "${var_name_tpl}"
  fi
}

function main {
  echo "${__envTemplate}" > "${out}" \
    && while read -r 'var_name'; do
      replace_var_in_file "${out}" "${var_name}" "${!var_name}" \
        || return 1
    done < "${__envArgumentNamesFile}" \
    && while read -r 'var_name'; do
      replace_var_in_file "${out}" "${var_name}" "$(echo -n "${!var_name}" | base64 --wrap=0)" \
        || return 1
    done < "${__envArgumentBase64NamesFile}" \
    && if grep --perl-regexp '__env[a-zA-Z]*__' "${out}"; then
      error Some arguments are not being used
    fi
}

main "${@}"
