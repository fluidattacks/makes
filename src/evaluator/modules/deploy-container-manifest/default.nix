{ __toModuleOutputs__, deployContainerManifest, ... }:
{ config, lib, ... }:
let
  makeOutput = name: args: {
    name = "/deployContainerManifest/${name}";
    value = deployContainerManifest {
      inherit (args) credentials;
      inherit (args) image;
      inherit (args) manifests;
      inherit name;
      inherit (args) setup;
      inherit (args) sign;
      inherit (args) tags;
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
          credentials = lib.mkOption { type = credentialsType; };
          image = lib.mkOption { type = lib.types.str; };
          manifests = lib.mkOption { type = lib.types.listOf manifestType; };
          setup = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.package;
          };
          sign = lib.mkOption {
            default = false;
            type = lib.types.bool;
          };
          tags = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.deployContainerManifest;
  };
}
