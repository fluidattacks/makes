# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT

# shellcheck shell=bash

case "${1}" in
  local) true ;;
  export) true ;;
  *) critical "First argument must be one of: local, export" ;;
esac

eval "${1}" "${2}=( __argArray__ )"
