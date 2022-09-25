# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeSearchPaths,
  outputs,
  ...
}:
makeSearchPaths {
  bin = [
    __nixpkgs__.cachix
    __nixpkgs__.git
    __nixpkgs__.gnutar
    __nixpkgs__.gzip
    __nixpkgs__.nixStable
  ];
  source = [
    outputs."/cli/env/runtime/pypi"
  ];
}