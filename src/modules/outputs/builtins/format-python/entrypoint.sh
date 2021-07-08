# shellcheck shell=bash

function main {
  local args_black=(
    --config '__envSettingsBlack__'
  )
  local args_isort=(
    --settings-path '__envSettingsIsort__'
  )
  local paths=__envTargets__

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
