{ __nixpkgs__, ... }:
{ config, lib, ... }: {
  options = {
    cache = {
      extra = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            enable = lib.mkOption {
              default = false;
              type = lib.types.bool;
            };
            pubKey = lib.mkOption {
              default = "";
              type = lib.types.str;
            };
            token = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            type = lib.mkOption { type = lib.types.enum [ "cachix" ]; };
            url = lib.mkOption { type = lib.types.str; };
            write = lib.mkOption {
              default = false;
              type = lib.types.bool;
            };
          };
        }));
      };
      readNixos = lib.mkOption {
        default = true;
        type = lib.types.bool;
      };
    };
  };
  config = {
    config = {
      cache = builtins.concatLists [
        (__nixpkgs__.lib.lists.optional config.cache.readNixos {
          url = "https://cache.nixos.org";
          pubKey =
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
          type = "other";
        })
        (builtins.filter (cache: cache.enable) (builtins.map (name: {
          inherit (config.cache.extra.${name}) enable;
          inherit (config.cache.extra.${name}) pubKey;
          inherit (config.cache.extra.${name}) token;
          inherit (config.cache.extra.${name}) type;
          inherit (config.cache.extra.${name}) url;
          inherit (config.cache.extra.${name}) write;
          inherit name;
        }) (builtins.attrNames config.cache.extra)))
      ];
    };
  };
}
