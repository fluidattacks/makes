{ __toModuleOutputs__, deployContainer, ... }:
{ config, lib, ... }:
let
  makeOutput = name: args: {
    name = "/deployContainer/${name}";
    value = deployContainer {
      inherit (args) credentials;
      inherit (args) image;
      inherit name;
      inherit (args) setup;
      inherit (args) sign;
      inherit (args) src;
    };
  };
in {
  options = {
    deployContainer = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          credentials = {
            token = lib.mkOption { type = lib.types.str; };
            user = lib.mkOption { type = lib.types.str; };
          };
          image = lib.mkOption { type = lib.types.str; };
          setup = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.package;
          };
          sign = lib.mkOption {
            default = false;
            type = lib.types.bool;
          };
          src = lib.mkOption { type = lib.types.package; };
        };
      }));
    };
  };
  config = { outputs = __toModuleOutputs__ makeOutput config.deployContainer; };
}
