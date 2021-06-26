{ config
, lib
, path
, ...
}:
{
  options = {
    apps = lib.mkOption {
      type = lib.types.anything;
    };
    src = lib.mkOption {
      default = path "/makes";
      type = lib.types.path;
    };
  };
  config = {
    apps = config.src;
  };
}
