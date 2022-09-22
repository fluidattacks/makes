# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeScript,
  makeTerraformEnvironment,
  ...
}: {
  debug ? false,
  name,
  setup,
  src,
  version,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argDebug__ = debug;
    __argSrc__ = src;
  };
  name = "test-terraform-for-${name}";
  searchPaths = {
    source =
      [
        (makeTerraformEnvironment {
          inherit version;
        })
      ]
      ++ setup;
  };
}
