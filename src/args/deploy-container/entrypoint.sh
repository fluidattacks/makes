# shellcheck shell=bash

function deploy {
  local credentials_token="${1}"
  local credentials_user="${2}"
  local image="${3}"
  local src="${4}"

  : && info Syncing container image: "${image}" \
    && skopeo \
      --insecure-policy \
      copy \
      --dest-creds "${credentials_user}:${credentials_token}" \
      "docker-archive://${src}" \
      "docker://${image}"
}

function sign {
  local credentials_token="${1}"
  local credentials_user="${2}"
  local image="${3}"
  local sign="${4}"

  if [ "${sign}" = "1" ]; then
    : && info "Signing container image: ${image}" \
      && cosign sign \
        --yes=true \
        --registry-username="${credentials_user}" \
        --registry-password="${credentials_token}" \
        "${image}"
  else
    : && info "Skipping signing container ${image}"
  fi
}

function main {
  local credentials_token="${__argCredentialsToken__}"
  local credentials_user="${__argCredentialsUser__}"
  local image="__argImage__"
  local sign="__argSign__"
  local src="__argSrc__"

  : && deploy \
    "${credentials_token}" \
    "${credentials_user}" \
    "${image}" \
    "${src}" \
    && sign \
      "${credentials_token}" \
      "${credentials_user}" \
      "${image}" \
      "${sign}"
}

main "${@}"
