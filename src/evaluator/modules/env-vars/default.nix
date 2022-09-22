# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __toModuleOutputs__,
  makeEnvVars,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeEnvVarsOutput = name: mapping: {
    name = "/envVars/${name}";
    value = makeEnvVars {
      inherit name;
      inherit mapping;
    };
  };
in {
  options = {
    envVars = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeEnvVarsOutput config.envVars;
  };
}
