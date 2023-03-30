# shellcheck shell=bash

function _get_credential {
  local credential="${1}"
  local session="${2}"

  echo "${session}" | jq -rec ".Credentials.${credential}"
}

function login {
  # AWS STS args
  local args=(
    --role-arn "${1}"
    --role-session-name "gitlab-${CI_PROJECT_ID}-${CI_PIPELINE_ID}-${CI_JOB_ID}"
    --web-identity-token "${CI_JOB_JWT_V2}"
    --duration-seconds "${2}"
  )

  # Retry logic
  local retries="__argRetries__"
  local wait="1"
  local try="1"
  local success="1"

  # Session variables
  local session
  export AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY
  export AWS_SESSION_TOKEN

  : \
    && while [ "${try}" -le "${retries}" ]; do
      if session="$(aws sts assume-role-with-web-identity "${args[@]}" 2> /dev/null)"; then
        success="0" \
          && break
      else
        info "Login failed. Attempt ${try} of ${retries}." \
          && sleep "${wait}" \
          && try=$((try + 1))
      fi
    done \
    && if [ "${success}" == "0" ]; then
      AWS_ACCESS_KEY_ID="$(_get_credential "AccessKeyId" "${session}")" \
        && AWS_SECRET_ACCESS_KEY="$(_get_credential "SecretAccessKey" "${session}")" \
        && AWS_SESSION_TOKEN="$(_get_credential "SessionToken" "${session}")"
    else
      error "Could not login to AWS."
    fi
}

function main {
  : \
    && info "Making secrets for aws from gitlab for __argName__:" \
    && if test -n "${CI_JOB_JWT_V2-}"; then
      info "Logging in as '__argName__' using GitLab OIDC." \
        && login "__argRoleArn__" "__argDuration__"
    else
      warn "It looks like this job is not running on GitLab CI. Skipping."
    fi
}

main "${@}"
