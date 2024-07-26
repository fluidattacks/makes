# shellcheck shell=bash

function deploy {
  local config="${1}"
  local credentials_token="${2}"
  local credentials_user="${3}"

  : && info "Deploying container manifest: ${config}" \
    && manifest-tool \
      --password "${credentials_token}" \
      --username "${credentials_user}" \
      push from-spec "${config}"
}

function sign {
  local sign="${1}"
  local config="${2}"
  local credentials_token="${3}"
  local credentials_user="${4}"
  local image

  if [ "${sign}" = "1" ]; then
    : && info "Signing container manifest" \
      && image="$(yq -rec '.image' "${config}")" \
      && cosign sign \
        --yes=true \
        --registry-username="${credentials_user}" \
        --registry-password="${credentials_token}" \
        "${image}"
  else
    : && info "Skipping signing container manifest"
  fi
}

function main {
  local config="__argConfig__"
  local credentials_token="${__argCredentialsToken__}"
  local credentials_user="${__argCredentialsUser__}"
  local sign="__argSign__"

  : && deploy "${config}" "${credentials_token}" "${credentials_user}" \
    && sign "${sign}" "${config}" "${credentials_token}" "${credentials_user}"
}

main "${@}"
