# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __toModuleOutputs__,
  makeSecretForGpgFromEnv,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeSecretForGpgFromEnvOutput = name: asciiArmorBlocks: {
    name = "/secretsForGpgFromEnv/${name}";
    value = makeSecretForGpgFromEnv {
      inherit name;
      inherit asciiArmorBlocks;
    };
  };
in {
  options = {
    secretsForGpgFromEnv = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    };
  };
  config = {
    outputs =
      __toModuleOutputs__
      makeSecretForGpgFromEnvOutput
      config.secretsForGpgFromEnv;
  };
}
