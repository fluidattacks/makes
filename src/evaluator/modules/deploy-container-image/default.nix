{ __toModuleOutputs__
, __outputsPrefix__
, deployContainerImage
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: { src, registry, tag }: {
    name = "${__outputsPrefix__}/deployContainerImage/${name}";
    value = deployContainerImage {
      containerImage = src;
      inherit name;
      inherit registry;
      inherit tag;
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
