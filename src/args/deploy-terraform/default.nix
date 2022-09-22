# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeScript,
  makeTerraformEnvironment,
  ...
}: {
  setup,
  name,
  version,
  src,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argSrc__ = src;
  };
  name = "deploy-terraform-for-${name}";
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
