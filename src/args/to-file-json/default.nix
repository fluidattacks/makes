# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{makeDerivation, ...}: name: expr:
makeDerivation {
  envFiles.envAll = builtins.toJSON expr;
  builder = "cp $envAllPath $out";
  local = true;
  inherit name;
}
