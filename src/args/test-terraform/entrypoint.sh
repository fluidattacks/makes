# shellcheck shell=bash

function main {
  cd "$(mktemp -d)" \
    && copy '__argSrc__' . \
    && info Initializing '__argSrc__' \
    && terraform init \
    && info Testing '__argSrc__' \
    && terraform plan -lock=false -refresh=true
}

main "${@}"
