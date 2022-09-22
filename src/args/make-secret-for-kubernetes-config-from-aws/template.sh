# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local config

  info Making secret for Kubernetes Config from AWS for __argName__: \
    && config="$(mktemp)" \
    && aws \
      --region '__argRegion__' \
      eks \
      update-kubeconfig \
      --name '__argCluster__' \
      --kubeconfig "${config}" \
    && export KUBECONFIG="${config}${KUBECONFIG:+:}${KUBECONFIG:-}"
}

main "${@}"
