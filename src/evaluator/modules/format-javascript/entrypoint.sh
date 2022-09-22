# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

function main {
  local args_prettier=(
    --config '__argSettingsPrettier__'
  )
  source __argTargets__/template local targets

  if running_in_ci_cd_provider; then
    args_prettier+=(--check)
  else
    args_prettier+=(--write)
  fi \
    && for target in "${targets[@]}"; do
      prettier "${args_prettier[@]}" "${target}"
    done
}

main "${@}"
