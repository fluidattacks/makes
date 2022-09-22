# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeDerivation,
  makePythonPypiEnvironment,
  ...
}: envTarget:
makeDerivation {
  env = {
    inherit envTarget;
    envScriptCvss = ./cvss.py;
  };
  name = "calculate-cvss-3";
  searchPaths = {
    source = [
      (makePythonPypiEnvironment {
        name = "cvss";
        sourcesYaml = ./sources.yaml;
      })
    ];
  };
  builder = ./builder.sh;
}
