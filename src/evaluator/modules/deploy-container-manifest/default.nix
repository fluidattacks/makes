{ __toModuleOutputs__, deployContainerManifest, ... }:
{ config, lib, ... }:
let
  makeOutput = name: args: {
    name = "/deployContainerManifest/${name}";
    value = deployContainerManifest {
      inherit (args) config;
      inherit (args) credentials;
      inherit name;
      inherit (args) setup;
      inherit (args) sign;
    };
  };

  manifestType = lib.types.submodule (_: {
    options = {
      image = lib.mkOption { type = lib.types.str; };
      platform = {
        architecture = lib.mkOption { type = lib.types.str; };
        os = lib.mkOption { type = lib.types.str; };
      };
    };
  });
  configType = lib.types.submodule (_: {
    options = {
      image = lib.mkOption { type = lib.types.str; };
      tags = lib.mkOption { type = lib.types.listOf lib.types.str; };
      manifests = lib.mkOption { type = lib.types.listOf manifestType; };
    };
  });
  credentialsType = lib.types.submodule (_: {
    options = {
      token = lib.mkOption { type = lib.types.str; };
      user = lib.mkOption { type = lib.types.str; };
    };
  });
in {
  options = {
    deployContainerManifest = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          config = lib.mkOption { type = configType; };
          credentials = lib.mkOption { type = credentialsType; };
          setup = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.package;
          };
          sign = lib.mkOption {
            default = false;
            type = lib.types.bool;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.deployContainerManifest;
  };
}
