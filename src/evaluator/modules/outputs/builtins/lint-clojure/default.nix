{ __toModuleOutputs__
, lintClojure
, pathCopy
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: targets: {
    name = "/lintClojure/${name}";
    value = lintClojure {
      inherit name;
      targets = builtins.map pathCopy targets;
    };
  };
in
{
  options = {
    lintClojure = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.lintClojure;
  };
}
