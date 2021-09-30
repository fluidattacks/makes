{ __toModuleOutputs__
, deployContainerImage
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: args: {
    name = "/deployContainerImage/${name}";
    value = deployContainerImage {
      inherit (args) attempts;
      containerImage = args.src;
      inherit name;
      inherit (args) registry;
      inherit (args) tag;
    };
  };
in
{
  options = {
    deployContainerImage = {
      images = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            attempts = lib.mkOption {
              default = 1;
              type = lib.types.ints.positive;
            };
            registry = lib.mkOption {
              type = lib.types.enum [
                "docker.io"
                "ghcr.io"
                "registry.gitlab.com"
              ];
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
