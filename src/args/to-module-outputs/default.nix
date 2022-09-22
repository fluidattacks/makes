# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  flatten,
  attrsMapToList,
  ...
}: makeOutput: set: (builtins.foldl'
  (all: one:
    all
    // (
      if one == {}
      then {}
      else {"${one.name}" = one.value;}
    ))
  {}
  (flatten (attrsMapToList makeOutput set)))
