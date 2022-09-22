# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makePythonPypiEnvironment,
  makeScript,
  toBashArray,
  ...
}: {
  name,
  targets,
  ...
}:
makeScript {
  name = "format-yaml-for-${name}";
  replace = {
    __argTargets__ = toBashArray targets;
  };
  searchPaths = {
    bin = [
      __nixpkgs__.findutils
      __nixpkgs__.git
    ];
    source = [
      (makePythonPypiEnvironment {
        name = "yamlfix";
        sourcesYaml = ./sources.yaml;
      })
    ];
  };
  entrypoint = ./entrypoint.sh;
}
