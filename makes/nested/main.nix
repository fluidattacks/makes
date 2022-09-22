# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  inputs,
  makeSearchPaths,
  ...
}:
makeSearchPaths {
  bin = [
    inputs.nixpkgs.git
  ];
}
