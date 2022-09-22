# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local container_image='__argContainerImage__'
  local tag="__argTag__"

  info Syncing container image: "${tag}" \
    && command=(
      skopeo
      --insecure-policy
      copy
      --dest-creds "${__argUser__}:${__argToken__}"
      "docker-archive://${container_image}"
      "docker://${tag}"
    ) \
    && temp="$(mktemp)" \
    && seq 1 __argAttempts__ > "${temp}" \
    && mapfile -t nums < "${temp}" \
    && for num in "${nums[@]}"; do
      if "${command[@]}"; then
        return 0
      else
        info Retrying number "${num}" ...
      fi
    done \
    && return 1 \
    || return 1
}

main "${@}"
