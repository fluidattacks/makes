# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{__nixpkgs__, ...}: version:
if version == "14"
then __nixpkgs__.nodejs-14_x
else if version == "16"
then __nixpkgs__.nodejs-16_x
else if version == "18"
then __nixpkgs__.nodejs-18_x
else abort "Supported node versions are: 14, 16 and 18"
