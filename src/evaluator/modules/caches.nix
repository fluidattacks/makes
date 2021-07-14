{ toJSONFile
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    caches = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          pubKey = lib.mkOption {
            type = lib.types.str;
          };
          url = lib.mkOption {
            type = lib.types.str;
          };
          writeSecret = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.str;
          };
        };
      }));
    };
    cachesAsJson = lib.mkOption {
      type = lib.types.package;
    };
  };
  config = {
    cachesAsJson = toJSONFile "caches.json" (config.caches // {
      __cache_nixos_org = {
        url = "https://cache.nixos.org";
        pubKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
      };
    });
  };
}
