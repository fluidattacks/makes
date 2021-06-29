# shellcheck shell=bash

function main {
  local credentials
  local container_image='__envContainerImage__'
  local tag="__envTag__"

  info Setting up credentials \
    && if test '__envRegistry__' = 'registry.gitlab.com'; then
      credentials="${CI_REGISTRY_USER}:${CI_REGISTRY_PASSWORD}"
    elif test '__envRegistry__' = 'docker.io'; then
      credentials="${DOCKER_HUB_USER}:${DOCKER_HUB_PASS}"
    else
      error Ivalid registry
    fi \
    && info Syncing container image: "${tag}" \
    && skopeo \
      --insecure-policy \
      copy \
      --dest-creds "${credentials}" \
      "docker-archive://${container_image}" \
      "docker://${tag}"
}

main "${@}"
