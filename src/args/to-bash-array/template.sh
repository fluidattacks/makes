# shellcheck shell=bash

case "${1}" in
  local) true ;;
  export) true ;;
  *) critical "First argument must be one of: local, export" ;;
esac

eval "${1}" "${2}=( __argArray__ )"
