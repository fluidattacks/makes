# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  toBashArray,
  makeScript,
  ...
}: {
  commands,
  extraArgs ? [],
  name,
  help ? null,
}:
makeScript {
  replace = {
    __argCommands__ = toBashArray commands;
    __argParallelArgs__ = toBashArray extraArgs;
  };
  entrypoint = ./entrypoint.sh;
  inherit help;
  name = "make-script-parallel-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.parallel
    ];
  };
}
