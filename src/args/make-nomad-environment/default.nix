# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeSearchPaths,
  ...
}: {version}: let
  nomad =
    {
      "1.0" = __nixpkgs__.nomad_1_0;
      "1.1" = __nixpkgs__.nomad_1_1;
    }
    .${version};
in
  makeSearchPaths {
    bin = [nomad];
  }
