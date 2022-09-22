# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  toBashArray,
  makeTemplate,
  toDerivationName,
  ...
}: {
  asciiArmorBlocks,
  name,
}:
makeTemplate {
  replace = {
    __argAsciiArmorBlocks__ = toBashArray asciiArmorBlocks;
    __argName__ = toDerivationName name;
  };
  name = "make-secret-for-gpg-from-env-for-${name}";
  searchPaths.bin = [__nixpkgs__.gnupg1orig];
  template = ./template.sh;
}
