{ __toModuleOutputs__
, lintWithLizard
, pathCopy
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: targets: {
    name = "/lintWithLizard/${name}";
    value = lintWithLizard {
      inherit name;
      targets = builtins.map pathCopy targets;
    };
  };
in
{
  options = {
    lintWithLizard = {
      targets = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.lintWithLizard.targets;
  };
}
