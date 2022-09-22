# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local args_black=(
    --config '__argSettingsBlack__'
  )
  local args_isort=(
    --settings-path '__argSettingsIsort__'
  )
  source __argTargets__/template local targets

  if running_in_ci_cd_provider; then
    args_black+=(--diff --check --color) \
      && args_isort+=(--diff --check --color)
  fi \
    && for target in "${targets[@]}"; do
      black "${args_black[@]}" "${target}" \
        && isort "${args_isort[@]}" "${target}"
    done
}

main "${@}"
