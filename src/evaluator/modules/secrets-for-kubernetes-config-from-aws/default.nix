{ __toModuleOutputs__
, makeSecretForKubernetesConfigFromAws
, ...
}:
{ config
, lib
, ...
}:
let
  secretForKubernetesConfigFromAwsType = lib.types.submodule (_: {
    options = {
      cluster = lib.mkOption {
        type = lib.types.str;
      };
      region = lib.mkOption {
        type = lib.types.str;
      };
    };
  });

  makeOutput = name: { cluster, region }: {
    name = "/secretsForKubernetesConfigFromAws/${name}";
    value = makeSecretForKubernetesConfigFromAws {
      inherit cluster;
      inherit name;
      inherit region;
    };
  };
in
{
  options = {
    secretsForKubernetesConfigFromAws = lib.mkOption {
      default = { };
      type = lib.types.attrsOf secretForKubernetesConfigFromAwsType;
    };
  };
  config = {
    outputs = __toModuleOutputs__
      makeOutput
      config.secretsForKubernetesConfigFromAws;
  };
}
