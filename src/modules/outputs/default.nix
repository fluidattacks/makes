{ head }:
{ config
, lib
, ...
}:
let args = {
  inherit config;
  inherit lib;
  builtinLambdas = import ../../args/builtin/lambdas.nix args;
  builtinShellCommands = ../../args/builtin/shell-commands.sh;
  builtinShellOptions = ../../args/builtin/shell-options.sh;
  deployContainerImage = import ../../args/deploy-container-image args;
  fakeSha256 = lib.fakeSha256;
  fakeSha512 = lib.fakeSha512;
  inputs = config.inputs;
  makeContainerImage = import ../../args/make-container-image args;
  makeDerivation = import ../../args/make-derivation args;
  makeNodeEnvironment = import ../../args/make-node-environment args;
  makePythonEnvironment = import ../../args/make-python-environment args;
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
  config = lib.mkIf (config.assertionsPassed) {
    attrs = config.inputs.makesPackages.nixpkgs.stdenv.mkDerivation {
      envList = builtins.toJSON (builtins.attrNames config.outputs);
      builder = builtins.toFile "builder" ''
        echo "$envList" > "$out"
      '';
      name = "makes-outputs-list";
    };
  };
}
