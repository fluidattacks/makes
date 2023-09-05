# shellcheck shell=bash

echo "Executing type check phase" \
  && mypy --version \
  && mypy . --config-file ./mypy.ini \
  && echo "Finished type check phase"
