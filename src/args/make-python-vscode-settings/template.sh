# shellcheck shell=bash

mkdir -p ./.vscode \
  && "__argPython__"/bin/python "__argPythonEntry__" ./.vscode/settings.json "__argPythonEnv__"
