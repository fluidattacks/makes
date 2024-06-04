{ __toModuleOutputs__, makeSecretForAwsFromEnv, ... }:
{ config, lib, ... }:
let
  secretForAwsFromEnvType = lib.types.submodule (_: {
    options = {
      accessKeyId = lib.mkOption {
        default = "AWS_ACCESS_KEY_ID";
        type = lib.types.str;
      };
      defaultRegion = lib.mkOption {
        default = "AWS_DEFAULT_REGION";
        type = lib.types.str;
      };
      secretAccessKey = lib.mkOption {
        default = "AWS_SECRET_ACCESS_KEY";
        type = lib.types.str;
      };
      sessionToken = lib.mkOption {
        default = "AWS_SESSION_TOKEN";
        type = lib.types.str;
      };
    };
  });
  makeSecretForAwsFromEnvOutput = name:
    { accessKeyId, defaultRegion, secretAccessKey, sessionToken, }: {
      name = "/secretsForAwsFromEnv/${name}";
      value = makeSecretForAwsFromEnv {
        inherit accessKeyId;
        inherit defaultRegion;
        inherit name;
        inherit secretAccessKey;
        inherit sessionToken;
      };
    };
in {
  options = {
    secretsForAwsFromEnv = lib.mkOption {
      default = { };
      type = lib.types.attrsOf secretForAwsFromEnvType;
    };
  };
  config = {
    outputs = (__toModuleOutputs__ makeSecretForAwsFromEnvOutput
      config.secretsForAwsFromEnv)
      // (__toModuleOutputs__ makeSecretForAwsFromEnvOutput {
        __default__ = {
          accessKeyId = "AWS_ACCESS_KEY_ID";
          defaultRegion = "AWS_DEFAULT_REGION";
          secretAccessKey = "AWS_SECRET_ACCESS_KEY";
          sessionToken = "AWS_SESSION_TOKEN";
        };
      });
  };
}
