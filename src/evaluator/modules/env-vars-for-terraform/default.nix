# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __toModuleOutputs__,
  makeEnvVarsForTerraform,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeEnvVarsForTerraformOutput = name: mapping: {
    name = "/envVarsForTerraform/${name}";
    value = makeEnvVarsForTerraform {
      inherit name;
      inherit mapping;
    };
  };
in {
  options = {
    envVarsForTerraform = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
    };
  };
  config = {
    outputs =
      __toModuleOutputs__
      makeEnvVarsForTerraformOutput
      config.envVarsForTerraform;
  };
}
