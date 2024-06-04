{ makeDynamoDb, __toModuleOutputs__, ... }:
{ config, lib, ... }:
let
  makeOutput = name: args: {
    name = "/dynamoDb/${name}";
    value = makeDynamoDb {
      inherit name;
      inherit (args) host;
      inherit (args) port;
      inherit (args) infra;
      inherit (args) daemonMode;
      inherit (args) dataDerivation;
      inherit (args) data;
    };
  };
in {
  options = {
    dynamoDb = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          host = lib.mkOption {
            default = "127.0.0.1";
            type = lib.types.str;
          };
          port = lib.mkOption {
            default = "8022";
            type = lib.types.str;
          };
          data = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.str;
          };
          dataDerivation = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.package;
          };
          infra = lib.mkOption {
            default = "";
            type = lib.types.str;
          };
          daemonMode = lib.mkOption {
            default = false;
            type = lib.types.bool;
          };
        };
      }));
    };
  };
  config = { outputs = __toModuleOutputs__ makeOutput config.dynamoDb; };
}
