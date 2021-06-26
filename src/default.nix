{ attrsFromPath
, config
, lib
, path
, ...
} @ args:
{
  options = {
    drvs = lib.mkOption {
      type = lib.types.anything;
    };
    src = lib.mkOption {
      default = path "/makes";
      type = lib.types.path;
    };
  };
  config = {
    drvs = attrsFromPath {
      args = args;
      path = config.src;
    };
  };
}
