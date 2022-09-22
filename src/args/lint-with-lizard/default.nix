# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  makeDerivation,
  makeDerivationParallel,
  makePythonPypiEnvironment,
  ...
}: {
  targets,
  name,
  ...
}: let
  makeTarget = envTarget:
    makeDerivation {
      env = {
        inherit envTarget;
      };
      name = "build-lint-with-lizard-for-${name}-${envTarget}";
      searchPaths = {
        source = [
          (makePythonPypiEnvironment {
            name = "lizard";
            sourcesYaml = ./sources.yaml;
          })
        ];
      };
      builder = ./builder.sh;
    };
in
  makeDerivationParallel {
    dependencies = builtins.map makeTarget targets;
    name = "lint-with-lizard-for-${name}";
  }
