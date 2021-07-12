# shellcheck shell=bash

function main {
  local args_black=(
    --config '__argSettingsBlack__'
  )
  local args_isort=(
    --settings-path '__argSettingsIsort__'
  )
  local paths=__argTargets__

  if running_in_ci_cd_provider; then
    args_black+=(--diff --check --color) \
      && args_isort+=(--diff --check --color)
  fi \
    && for path in "${paths[@]}"; do
      black "${args_black[@]}" "${path}" \
        && isort "${args_isort[@]}" "${path}"
    done
}

main "${@}"
