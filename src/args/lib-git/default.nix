# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeTemplate,
  ...
}:
makeTemplate {
  name = "lib-git";
  searchPaths.bin = [__nixpkgs__.git];
  template = ./template.sh;
}
