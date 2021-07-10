{ config
, head
, lib
}:
let args = {
  inherit config;
  builtinLambdas = import ./builtin/lambdas.nix args;
  builtinShellCommands = ./builtin/shell-commands.sh;
  builtinShellOptions = ./builtin/shell-options.sh;
  deployContainerImage = import ./deploy-container-image args;
  fakeSha256 = lib.fakeSha256;
  fakeSha512 = lib.fakeSha512;
  fetchNixpkgs = import ./fetchers/nixpkgs.nix args;
  fetchUrl = import ./fetchers/url.nix args;
  fetchZip = import ./fetchers/zip.nix args;
  inputs = config.inputs;
  inherit lib;
  makeContainerImage = import ./make-container-image args;
  makeDerivation = import ./make-derivation args;
  makeNodeEnvironment = import ./make-node-environment args;
  makeParallel = import ./make-parallel args;
  makePythonEnvironment = import ./make-python-environment args;
  makeScript = import ./make-script args;
  makeSearchPaths = import ./make-search-paths args;
  makeTemplate = import ./make-template args;
  outputs = config.outputs;
  path = path: head + path;
};
in args
