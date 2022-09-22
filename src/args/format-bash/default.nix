# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  toBashArray,
  makeScript,
  ...
}: {
  name,
  targets,
  ...
}:
makeScript {
  replace = {
    __argTargets__ = toBashArray targets;
  };
  name = "format-bash-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.shfmt
    ];
  };
  entrypoint = ./entrypoint.sh;
}
