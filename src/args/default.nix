{ __nixpkgs__
, head
, headImpure
, inputs
, makesVersion
, outputs
, requiredMakesVersion
}:
let args = {
  inherit __nixpkgs__;
  builtinLambdas = import ./builtin/lambdas.nix args;
  builtinShellCommands = ./builtin/shell-commands.sh;
  builtinShellOptions = ./builtin/shell-options.sh;
  deployContainerImage = import ./deploy-container-image args;
  fakeSha256 = __nixpkgs__.lib.fakeSha256;
  fetchNixpkgs = import ./fetchers/nixpkgs.nix args;
  fetchUrl = import ./fetchers/url.nix args;
  fetchZip = import ./fetchers/zip.nix args;
  inherit inputs;
  makeContainerImage = import ./make-container-image args;
  makeDerivation = import ./make-derivation args;
  makeNodeEnvironment = import ./make-node-environment args;
  makeParallel = import ./make-parallel args;
  makePythonEnvironment = import ./make-python-environment args;
  inherit makesVersion;
  makeScript = import ./make-script args;
  makeSearchPaths = import ./make-search-paths args;
  makeTemplate = import ./make-template args;
  inherit outputs;
  path = path: head + path;
  pathImpure = path: headImpure + path;
  inherit requiredMakesVersion;
};
in args
