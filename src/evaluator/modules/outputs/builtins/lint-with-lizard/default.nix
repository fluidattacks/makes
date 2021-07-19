{ asBashArray
, makeDerivation
, path
, makePythonEnvironment
, lintWithLizard
, __toModuleOutputs__
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = target: {
    name = "/lintWithLizard${target}";
    value = lintWithLizard {
      name = target;
      inherit target;
    };
  };
in
{
  options = {
    lintWithLizard = {
      targets = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.lintWithLizard.targets;
  };
}
