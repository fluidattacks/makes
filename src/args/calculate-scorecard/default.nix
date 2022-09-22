# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeScript,
  ...
}: {
  checks,
  format,
  target,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "calculate-scorecard";
  replace = {
    __argChecks__ = checks;
    __argFormat__ = format;
    __argTarget__ = target;
  };
  searchPaths.bin = [
    __nixpkgs__.coreutils
    __nixpkgs__.gnugrep
    __nixpkgs__.jq
    __nixpkgs__.scorecard
  ];
}
