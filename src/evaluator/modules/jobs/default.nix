{ __toModuleOutputs__, ... }:
{ config, lib, ... }:
let
  makeOutput = name: value: {
    inherit name;
    inherit value;
  };
in {
  options.jobs = lib.mkOption {
    default = { };
    type = lib.types.attrsOf lib.types.package;
  };
  config.outputs = __toModuleOutputs__ makeOutput config.jobs;
}
