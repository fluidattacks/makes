# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  filterAttrs,
  projectPath,
  ...
}: rel: let
  isDir = _: value: value == "directory";
  ls = builtins.readDir (projectPath rel);
  dirs = filterAttrs isDir ls;
  dirNames = builtins.attrNames dirs;
in
  builtins.map builtins.unsafeDiscardStringContext dirNames
