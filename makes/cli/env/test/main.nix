# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{makePythonPypiEnvironment, ...}:
makePythonPypiEnvironment {
  name = "cli-env-test";
  sourcesYaml = ./pypi-sources.yaml;
}
