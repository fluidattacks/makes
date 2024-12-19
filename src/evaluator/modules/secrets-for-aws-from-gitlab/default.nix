{ __toModuleOutputs__, makeSecretForAwsFromGitlab, ... }:
{ config, lib, ... }:
let
  type = lib.types.submodule (_: {
    options = {
      duration = lib.mkOption {
        default = 3600;
        type = lib.types.ints.positive;
      };
      retries = lib.mkOption {
        default = 15;
        type = lib.types.ints.positive;
      };
      roleArn = lib.mkOption { type = lib.types.str; };
    };
  });
  output = name:
    { duration, retries, roleArn, }: {
      name = "/secretsForAwsFromGitlab/${name}";
      value = makeSecretForAwsFromGitlab {
        inherit duration;
        inherit name;
        inherit retries;
        inherit roleArn;
      };
    };
in {
  options = {
    secretsForAwsFromGitlab = lib.mkOption {
      default = { };
      type = lib.types.attrsOf type;
    };
  };
  config = {
    outputs = __toModuleOutputs__ output config.secretsForAwsFromGitlab;
  };
}
