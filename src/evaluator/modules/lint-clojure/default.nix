{ __toModuleOutputs__
, __outputsPrefix__
, lintClojure
, projectPath
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: targets: {
    name = "${__outputsPrefix__}/lintClojure/${name}";
    value = lintClojure {
      inherit name;
      targets = builtins.map projectPath targets;
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
