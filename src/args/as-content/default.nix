# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
expr:
if builtins.isPath expr
then builtins.readFile expr
else if builtins.isString expr
then
  if (builtins.substring 0 11 expr) == "/nix/store/"
  then builtins.readFile expr
  else expr
else abort "Expected a store path or a string, got: ${builtins.typeOf expr}"
