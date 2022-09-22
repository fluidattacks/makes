# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{__nixpkgs__, ...}: str: let
  lib = __nixpkgs__.lib;
  head = lib.strings.toUpper (builtins.substring 0 1 str);
  tail = builtins.concatStringsSep "" (
    builtins.tail (lib.stringToCharacters str)
  );
in
  head + tail
