{ __toModuleOutputs__
, makeSecretForEnvFromSops
, projectPath
, ...
}:
{ config
, lib
, ...
}:
let
  secretForEnvFromSopsType = lib.types.submodule (_: {
    options = {
      vars = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
      target = lib.mkOption {
        type = lib.types.str;
      };
    };
  });

  makeOutput = name: { target, vars }: {
    name = "/secretsForEnvFromSops/${name}";
    value = makeSecretForEnvFromSops {
      inherit name;
      target = projectPath target;
      inherit vars;
    };
  };
in
{
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
