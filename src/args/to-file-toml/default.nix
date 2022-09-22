# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeDerivation,
  ...
}: name: expr:
makeDerivation {
  envFiles.envAll = builtins.toJSON expr;
  builder = "yj -jt < $envAllPath > $out";
  local = true;
  inherit name;
  searchPaths.bin = [__nixpkgs__.yj];
}
