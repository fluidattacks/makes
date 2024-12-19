{ __toModuleOutputs__, ... }:
{ config, lib, ... }:
let
  makeOutput = name: value: {
    name = if lib.strings.hasPrefix "/" name then
      name
    else
      abort
      ''The job "${name}" must begin with a slash. Rename it to "/${name}"'';
    inherit value;
  };
in {
  options.jobs = lib.mkOption {
    default = { };
    type = lib.types.attrsOf lib.types.package;
  };
  config.outputs = __toModuleOutputs__ makeOutput config.jobs;
}
