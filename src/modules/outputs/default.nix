{ head
, packages
}:
{ config
, lib
, ...
}:
let args = {
  builtinLambdas = import ../../args/builtin/lambdas.nix args;
  builtinShellCommands = ../../args/builtin/shell-commands.sh;
  builtinShellOptions = ../../args/builtin/shell-options.sh;
  config = config;
  inputs = config.inputs;
  outputs = config.outputs;
  lib = lib;
  path = path: head + path;
  makeDerivation = import ../../args/make-derivation args;
  makeEntrypoint = import ../../args/make-entrypoint args;
  makeSearchPaths = import ../../args/make-search-paths args;
  makeTemplate = import ../../args/make-template args;
};
in
{
  options = {
    outputs = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
    };
  };
  imports = [
    (import ./builtins args)
    (import ./custom.nix args)
  ];
}
