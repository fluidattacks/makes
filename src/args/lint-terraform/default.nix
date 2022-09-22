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
  config,
  name,
  version,
  src,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argConfig__ = config;
    __argSrc__ = src;
  };
  name = "lint-terraform-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.tflint
    ];
    source =
      [
        (makeTerraformEnvironment {
          inherit version;
        })
      ]
      ++ setup;
  };
}
