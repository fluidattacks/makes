# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  toBashArray,
  makeDerivation,
  ...
}: {
  name,
  config,
  targets,
}:
makeDerivation {
  env = {
    envConfig = config;
    envTargets = toBashArray targets;
  };
  name = "lint-markdown-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.mdl
    ];
  };
  builder = ./builder.sh;
}
