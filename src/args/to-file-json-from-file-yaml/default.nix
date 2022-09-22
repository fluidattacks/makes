# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeDerivation,
  ...
}: envSrc:
makeDerivation {
  env = {
    inherit envSrc;
  };
  local = true;
  name = "to-file-json-from-file-yaml";
  searchPaths = {
    bin = [
      __nixpkgs__.yq
    ];
  };
  builder = ./builder.sh;
}
