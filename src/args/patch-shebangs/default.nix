# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeTemplate,
  ...
}:
makeTemplate {
  name = "patch-shebangs";
  searchPaths.bin = [__nixpkgs__.findutils __nixpkgs__.gnused];
  template = ./template.sh;
}
