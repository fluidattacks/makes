{ listOptional
, toFileJson
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    cache = {
      readAndWrite = {
        enable = lib.mkOption {
          default = false;
          type = lib.types.bool;
        };
        name = lib.mkOption {
          type = lib.types.str;
        };
        pubKey = lib.mkOption {
          type = lib.types.str;
        };
      };
      readExtra = lib.mkOption {
        default = [ ];
        type = lib.types.listOf (lib.types.submodule (_: {
          options = {
            pubKey = lib.mkOption {
              type = lib.types.str;
            };
            url = lib.mkOption {
              type = lib.types.str;
            };
          };
        }));
      };
      readNixos = lib.mkOption {
        default = true;
        type = lib.types.bool;
      };
    };
    cacheAsJson = lib.mkOption {
      type = lib.types.package;
    };
  };
  config = {
    cacheAsJson = toFileJson "cache.json" (builtins.concatLists [
      (listOptional config.cache.readNixos {
        url = "https://cache.nixos.org";
        pubKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
        type = "other";
      })
      (listOptional config.cache.readAndWrite.enable {
        name = config.cache.readAndWrite.name;
        url = "https://${config.cache.readAndWrite.name}.cachix.org";
        pubKey = config.cache.readAndWrite.pubKey;
        type = "cachix";
      })
      (builtins.map
        (cache: {
          inherit (cache) url;
          inherit (cache) pubKey;
          type = "other";
        })
        config.cache.readExtra)
    ]);
  };
}
