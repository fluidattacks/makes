# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __toModuleOutputs__,
  makeSecretForTerraformFromEnv,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeSecretForTerraformFromEnvOutput = name: mapping: {
    name = "/secretsForTerraformFromEnv/${name}";
    value = makeSecretForTerraformFromEnv {
      inherit name;
      inherit mapping;
    };
  };
in {
  options = {
    secretsForTerraformFromEnv = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
    };
  };
  config = {
    outputs =
      __toModuleOutputs__
      makeSecretForTerraformFromEnvOutput
      config.secretsForTerraformFromEnv;
  };
}
