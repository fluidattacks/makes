# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  makeScript,
  makeTerraformEnvironment,
  toBashArray,
  ...
}: {
  setup,
  name,
  version,
  reDeploy ? false,
  resources,
  src,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argResources__ = toBashArray resources;
    __argReDeploy__ = reDeploy;
    __argSrc__ = src;
  };
  name = "taint-terraform-for-${name}";
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
