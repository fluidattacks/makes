# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeTemplate,
  ...
}:
makeTemplate {
  name = "manage-ports";
  searchPaths = {
    bin = [
      __nixpkgs__.lsof
      __nixpkgs__.netcat
    ];
  };
  template = ./template.sh;
}
