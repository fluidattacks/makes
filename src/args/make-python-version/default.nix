# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{__nixpkgs__, ...}: version:
{
  "3.7" = __nixpkgs__.python37;
  "3.8" = __nixpkgs__.python38;
  "3.9" = __nixpkgs__.python39;
  "3.10" = __nixpkgs__.python310;
}
.${version}
