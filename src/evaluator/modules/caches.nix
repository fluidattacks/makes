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
          secretName = lib.mkOption {
            type = lib.types.str;
          };
        };
      }));
    };
    cachesAsJson = lib.mkOption {
      type = lib.types.package;
    };
  };
  config = {
    cachesAsJson = toJSONFile "caches.json" config.caches;
  };
}
