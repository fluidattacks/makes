# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  inputs,
  makeScript,
  ...
}:
makeScript {
  name = "license";
  entrypoint = ./entrypoint.sh;
  searchPaths.bin = [
    inputs.nixpkgs.findutils
    inputs.nixpkgs.reuse
  ];
}
