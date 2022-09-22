# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  __toModuleOutputs__,
  taintTerraform,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeOutput = name: {
    reDeploy,
    resources,
    setup,
    src,
    version,
  }: {
    name = "/taintTerraform/${name}";
    value = taintTerraform {
      inherit name;
      inherit reDeploy;
      inherit setup;
      src = "." + src;
      inherit resources;
      inherit version;
    };
  };
in {
  options = {
    taintTerraform = {
      modules = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            reDeploy = lib.mkOption {
              default = false;
              type = lib.types.bool;
            };
            resources = lib.mkOption {
              type = lib.types.listOf lib.types.str;
            };
            setup = lib.mkOption {
              default = [];
              type = lib.types.listOf lib.types.package;
            };
            src = lib.mkOption {
              type = lib.types.str;
            };
            version = lib.mkOption {
              type = lib.types.enum [
                "0.14"
                "0.15"
                "1.0"
              ];
            };
          };
        }));
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.taintTerraform.modules;
  };
}
