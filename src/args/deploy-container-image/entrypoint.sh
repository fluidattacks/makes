# shellcheck shell=bash

function main {
  local credentials
  local container_image='__argContainerImage__'
  local tag="__argTag__"

  info Setting up credentials \
    && if test '__argRegistry__' = 'registry.gitlab.com'; then
      credentials="${CI_REGISTRY_USER}:${CI_REGISTRY_PASSWORD}"
    elif test '__argRegistry__' = 'docker.io'; then
      credentials="${DOCKER_HUB_USER}:${DOCKER_HUB_PASS}"
    elif test '__argRegistry__' = 'ghcr.io'; then
      credentials="${GITHUB_ACTOR}:${GITHUB_TOKEN}"
    else
      error Ivalid registry
    fi \
    && info Syncing container image: "${tag}" \
    && command=(
      skopeo
      --insecure-policy
      copy
      --dest-creds "${credentials}"
      "docker-archive://${container_image}"
      "docker://${tag}"
    ) \
    && seq 1 __argAttempts__ | while read -r num; do
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
