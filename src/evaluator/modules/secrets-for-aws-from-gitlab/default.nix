{
  __toModuleOutputs__,
  makeSecretForAwsFromGitlab,
  ...
}: {
  config,
  lib,
  ...
}: let
  type = lib.types.submodule (_: {
    options = {
      roleArn = lib.mkOption {
        type = lib.types.str;
      };
      duration = lib.mkOption {
        default = 3600;
        type = lib.types.ints.positive;
      };
    };
  });
  output = name: {
    roleArn,
    duration,
  }: {
    name = "/secretsForAwsFromGitlab/${name}";
    value = makeSecretForAwsFromGitlab {
      inherit duration;
      inherit name;
      inherit roleArn;
    };
  };
in {
  options = {
    secretsForAwsFromGitlab = lib.mkOption {
      default = {};
      type = lib.types.attrsOf type;
    };
  };
  config = {
    outputs = __toModuleOutputs__ output config.secretsForAwsFromGitlab;
  };
}
