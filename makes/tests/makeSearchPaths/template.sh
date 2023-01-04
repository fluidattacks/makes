# shellcheck shell=bash

set -x \
  && test "${*}" == "a b c"
