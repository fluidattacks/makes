{ deployContainerImage
, lib
, ...
}:
{ config
, ...
}:
{
  options = {
    deployContainerImage = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      images = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
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
    outputs = lib.mkIf config.deployContainerImage.enable
      (lib.attrsets.mapAttrs'
        (name: { src, registry, tag }: {
          name = "/deployContainerImage/${name}";
          value = deployContainerImage {
            containerImage = src;
            inherit name;
            inherit registry;
            inherit tag;
          };
        })
        config.deployContainerImage.images);
  };
}
