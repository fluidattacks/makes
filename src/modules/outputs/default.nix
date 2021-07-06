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
  deployContainerImage = import ../../args/deploy-container-image args;
  inputs = config.inputs;
  lib = lib;
  makeContainerImage = import ../../args/make-container-image args;
  makeDerivation = import ../../args/make-derivation args;
  makeScript = import ../../args/make-script args;
  makeSearchPaths = import ../../args/make-search-paths args;
  makeTemplate = import ../../args/make-template args;
  outputs = config.outputs;
  path = path: head + path;
};
in
{
  imports = [
    (import ./builtins args)
    (import ./custom.nix args)
  ];
  options = {
    attrs = lib.mkOption {
      type = lib.types.package;
    };
    outputs = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
    };
  };
  config = {
    attrs = config.inputs.makesPackages.nixpkgs.stdenv.mkDerivation {
      envList = builtins.toJSON (builtins.attrNames config.outputs);
      builder = builtins.toFile "builder" ''
        echo "$envList" > "$out"
      '';
      name = "makes-outputs-list";
    };
  };
}
