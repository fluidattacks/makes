{ __toModuleOutputs__, makeSearchPaths, ... }:
{ config, lib, ... }:
let
  makeOutput = name: searchPaths: {
    name = "/dev/${name}";
    value = makeSearchPaths (searchPaths // { withAction = false; });
  };
in {
  options = {
    dev = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.attrs;
    };
  };
  config = { outputs = __toModuleOutputs__ makeOutput config.dev; };
}
