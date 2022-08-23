# shellcheck shell=bash

function _get_credential {
  local credential="${1}"
  local session="${2}"

  echo "${session}" | jq -rec ".Credentials.${credential}"
}

function login {
  local args=(
    --role-arn "${1}"
    --role-session-name "gitlab-${CI_PROJECT_ID}-${CI_PIPELINE_ID}-${CI_JOB_ID}"
    --web-identity-token "${CI_JOB_JWT_V2}"
    --duration-seconds "${2}"
  )
  local session
  export AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY
  export AWS_SESSION_TOKEN

  : \
    && session="$(aws sts assume-role-with-web-identity "${args[@]}")" \
    && AWS_ACCESS_KEY_ID="$(_get_credential "AccessKeyId" "${session}")" \
    && AWS_SECRET_ACCESS_KEY="$(_get_credential "SecretAccessKey" "${session}")" \
    && AWS_SESSION_TOKEN="$(_get_credential "SessionToken" "${session}")"
}

function main {
  : \
    && info "Making secrets for aws from gitlab for __argName__:" \
    && if test -n "${CI_JOB_JWT_V2:-}"; then
      info "Logging in as '__argName__' using GitLab OIDC." \
        && login "__argRoleArn__" "__argDuration__"
    else
      warn "Looks like this job is not running on GitLab CI. Skipping."
    fi
}

main "${@}"
