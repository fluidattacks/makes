# shellcheck shell=bash

echo "Executing test phase" \
  && pytest --version \
  && pytest ./tests \
  && echo "Finished test phase"
