# shellcheck shell=bash

function main {
  local access_key_id_name='__argAccessKeyId__'
  local default_region_name='__argDefaultRegion__'
  local secret_access_key_name='__argSecretAcessKey__'
  local session_token_name='__argSessionToken__'

  info Making secrets for AWS from environment variables for __argName__: \
    && require_env_var "${access_key_id_name}" \
    && require_env_var "${secret_access_key_name}" \
    && export AWS_ACCESS_KEY_ID="${!access_key_id_name}" \
    && info - AWS_ACCESS_KEY_ID from "${access_key_id_name}" \
    && export AWS_CONFIG_FILE \
    && AWS_CONFIG_FILE="$(mktemp)" \
    && info - AWS_CONFIG_FILE="${AWS_CONFIG_FILE}" \
    && export AWS_DEFAULT_REGION="${!default_region_name:-us-east-1}" \
    && info - AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    && export AWS_SECRET_ACCESS_KEY="${!secret_access_key_name}" \
    && info - AWS_SECRET_ACCESS_KEY from "${secret_access_key_name}" \
    && export AWS_SESSION_TOKEN="${!session_token_name-}" \
    && info - AWS_SESSION_TOKEN from "${session_token_name}" \
    && export AWS_SHARED_CREDENTIALS_FILE \
    && AWS_SHARED_CREDENTIALS_FILE="$(mktemp)" \
    && info - AWS_SHARED_CREDENTIALS_FILE="${AWS_SHARED_CREDENTIALS_FILE}"

}

main "${@}"
