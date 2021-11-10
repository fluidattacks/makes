# shellcheck shell=bash

function main {
  source "${envOptions}"/template local options

  mkdir "${out}" \
    && openssl req \
      -days "${envDays}" \
      -keyout "${out}/cert.key" \
      -new \
      -newkey "${envKeyType}" \
      -nodes \
      -out "${out}/cert.crt" \
      "${options[@]}" \
      -x509 \
    && openssl x509 \
      -in "${out}/cert.crt" \
      -inform 'pem' \
      -noout \
      -text
}

main "${@}"
