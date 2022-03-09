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
