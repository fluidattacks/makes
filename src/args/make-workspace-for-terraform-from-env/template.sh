# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function _workspace_exists {
  local workspace="${1}"

  if terraform workspace list | grep -q "${workspace}"; then
    return 0
  else
    return 1
  fi
}

function _select_workspace {
  local src="${1}"
  local variable="${2}"
  local workspace

  : \
    && if [ "${variable}" = "" ]; then
      info "Using default workspace" \
        && workspace="default"
    else
      info "Using workspace variable: ${variable}" \
        && require_env_var "${variable}" \
        && workspace="${!variable}"
    fi \
    && if _workspace_exists "${workspace}"; then
      info "Selecting already-existing workspace: ${workspace}" \
        && terraform workspace select "${workspace}"
    else
      info "Creating new workspace: ${workspace}" \
        && terraform workspace new "${workspace}"
    fi
}

function main {
  local src='__argSrc__'
  local variable='__argVariable__'
  export TF_LOG

  : \
    && pushd "${src}" \
    && info "Initializing ${src}" \
    && terraform init \
    && _select_workspace "${src}" "${variable}" \
    && popd \
    || return 1
}

main "${@}"
