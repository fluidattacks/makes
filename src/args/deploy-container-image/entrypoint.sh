# shellcheck shell=bash

function deploy {
  local attempts="${1}"
  local container_image="${2}"
  local credentials_token="${3}"
  local credentials_user="${4}"
  local tag="${5}"

  : \
    && info Syncing container image: "${tag}" \
    && command=(
      skopeo
      --insecure-policy
      copy
      --dest-creds "${credentials_user}:${credentials_token}"
      "docker-archive://${container_image}"
      "docker://${tag}"
    ) \
    && temp="$(mktemp)" \
    && seq 1 "${attempts}" > "${temp}" \
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

function sign {
  local credentials_token="${1}"
  local credentials_user="${2}"
  local registry="${3}"
  local sign="${4}"
  local tag="${5}"

  if [ "${sign}" = "1" ]; then
    : \
      && info "Signing container image: ${tag}" \
      && cosign login "${registry}" -u "${credentials_user}" -p "${credentials_token}" \
      && cosign sign -y "${tag}"
  else
    : \
      && info "Skipping signing container ${tag}"
  fi
}

function main {
  local attempts="__argAttempts__"
  local container_image="__argContainerImage__"
  local credentials_token="${__argCredentialsToken__}"
  local credentials_user="${__argCredentialsUser__}"
  local registry="__argRegistry__"
  local sign="__argSign__"
  local tag="__argTag__"

  export COSIGN_EXPERIMENTAL="1"

  : \
    && deploy \
      "${attempts}" \
      "${container_image}" \
      "${credentials_token}" \
      "${credentials_user}" \
      "${tag}" \
    && sign \
      "${credentials_token}" \
      "${credentials_user}" \
      "${registry}" \
      "${sign}" \
      "${tag}"
}

main "${@}"
