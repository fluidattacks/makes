{ __nixpkgs__
, head
, headImpure
, inputs
, makesVersion
, outputs
}:
let
  args = {
    inherit __nixpkgs__;
    __shellCommands__ = ./shell-commands/makes-setup.sh;
    __shellOptions__ = ./shell-options/makes-setup.sh;
    asBashArray = args: "( ${lib.strings.escapeShellArgs args} )";
    asContent = import ./as-content/default.nix;
    deployContainerImage = import ./deploy-container-image/default.nix args;
    fakeSha256 = lib.fakeSha256;
    fetchNixpkgs = import ./fetchers/nixpkgs.nix args;
    fetchUrl = import ./fetchers/url.nix args;
    fetchZip = import ./fetchers/zip.nix args;
    formatBash = import ./format-bash args;
    formatTerraform = import ./format-terraform args;
    getAttr = import ./get-attr/default.nix;
    inherit inputs;
    lintTerraform = import ./lint-terraform/default.nix args;
    makeContainerImage = import ./make-container-image/default.nix args;
    makeDerivation = import ./make-derivation/default.nix args;
    makeDerivationParallel = import ./make-derivation-parallel/default.nix args;
    makeNodeEnvironment = import ./make-node-environment/default.nix args;
    makePythonEnvironment = import ./make-python-environment/default.nix args;
    makeScript = import ./make-script/default.nix args;
    makeScriptParallel = import ./make-script-parallel/default.nix args;
    makeSearchPaths = import ./make-search-paths/default.nix args;
    makeTerraformEnvironment = import ./make-terraform-environment/default.nix args;
    inherit makesVersion;
    makeTemplate = import ./make-template/default.nix args;
    inherit outputs;
    path = path: head + path;
    pathImpure = path: headImpure + path;
    sortAscii = builtins.sort (a: b: a < b);
    sortAsciiCaseless = builtins.sort (a: b: lib.toLower a < lib.toLower b);
    toDerivationName = lib.strings.sanitizeDerivationName;
    toFileJson = import ./to-file-json/default.nix args;
    toFileLst = import ./to-file-lst/default.nix;
  };

  lib = __nixpkgs__.lib;
in
args
