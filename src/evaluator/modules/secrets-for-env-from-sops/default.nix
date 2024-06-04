{ __toModuleOutputs__, makeSecretForEnvFromSops, projectPath, ... }:
{ config, lib, ... }:
let
  secretForEnvFromSopsType = lib.types.submodule (_: {
    options = {
      manifest = lib.mkOption { type = lib.types.str; };
      vars = lib.mkOption { type = lib.types.listOf lib.types.str; };
    };
  });

  makeOutput = name:
    { manifest, vars, }: {
      name = "/secretsForEnvFromSops/${name}";
      value = makeSecretForEnvFromSops {
        manifest = projectPath manifest;
        inherit name;
        inherit vars;
      };
    };
in {
  options = {
    secretsForEnvFromSops = lib.mkOption {
      default = { };
      type = lib.types.attrsOf secretForEnvFromSopsType;
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.secretsForEnvFromSops;
  };
}
