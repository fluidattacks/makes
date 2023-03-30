{
  __toModuleOutputs__,
  deployContainerImage,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeOutput = name: args: {
    name = "/deployContainerImage/${name}";
    value = deployContainerImage {
      inherit (args) attempts;
      inherit (args) credentials;
      containerImage = args.src;
      inherit name;
      inherit (args) registry;
      inherit (args) setup;
      inherit (args) sign;
      inherit (args) tag;
    };
  };
in {
  options = {
    deployContainerImage = {
      images = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            attempts = lib.mkOption {
              default = 1;
              type = lib.types.ints.positive;
            };
            credentials = {
              token = lib.mkOption {
                type = lib.types.str;
              };
              user = lib.mkOption {
                type = lib.types.str;
              };
            };
            registry = lib.mkOption {
              type = lib.types.str;
            };
            setup = lib.mkOption {
              default = [];
              type = lib.types.listOf lib.types.package;
            };
            sign = lib.mkOption {
              default = false;
              type = lib.types.bool;
            };
            src = lib.mkOption {
              type = lib.types.package;
            };
            tag = lib.mkOption {
              type = lib.types.str;
            };
          };
        }));
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.deployContainerImage.images;
  };
}
