# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeDerivation,
  toBashArray,
  ...
}: {
  days ? 30,
  keyType ? "rsa:4096",
  name,
  options,
  ...
}:
makeDerivation {
  env = {
    envDays = builtins.toString days;
    envKeyType = keyType;
    envOptions = toBashArray (builtins.concatLists options);
  };
  builder = ./builder.sh;
  name = "make-ssl-certificate-for-${name}";
  searchPaths = {
    bin = [__nixpkgs__.openssl];
  };
}
