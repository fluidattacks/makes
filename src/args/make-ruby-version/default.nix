# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{__nixpkgs__, ...}: version:
{
  "2.7" = __nixpkgs__.ruby_2_7;
  "3.0" = __nixpkgs__.ruby_3_0;
}
.${version}
