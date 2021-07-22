{ __nixpkgs__
, projectSrc
, projectSrcMutable
, inputs
, outputs
}:
let
  projectSrcInStore = builtins.path {
    name = "head";
    path = projectSrc;
  };

  args = {
    inherit __nixpkgs__;
    __shellCommands__ = ./shell-commands/makes-setup.sh;
    __shellOptions__ = ./shell-options/makes-setup.sh;
    __toModuleOutputs__ = import ./to-module-outputs/default.nix args;
    asBashArray = import ./as-bash-array/default.nix args;
    asBashMap = import ./as-bash-map/default.nix args;
    asContent = import ./as-content/default.nix;
    deployContainerImage = import ./deploy-container-image/default.nix args;
    deployTerraform = import ./deploy-terraform/default.nix args;
    fakeSha256 = lib.fakeSha256;
    fetchGithub = import ./fetchers/github.nix args;
    fetchNixpkgs = import ./fetchers/nixpkgs.nix args;
    fetchUrl = import ./fetchers/url.nix args;
    fetchZip = import ./fetchers/zip.nix args;
    formatBash = import ./format-bash args;
    formatTerraform = import ./format-terraform args;
    getAttr = import ./get-attr/default.nix;
    inherit inputs;
    lintGitCommitMsg = import ./lint-git-commit-msg/default.nix args;
    lintGitMailMap = import ./lint-git-mailmap/default.nix args;
    lintMarkdown = import ./lint-markdown/default.nix args;
    lintTerraform = import ./lint-terraform/default.nix args;
    lintWithAjv = import ./lint-with-ajv/default.nix args;
    lintWithLizard = import ./lint-with-lizard/default.nix args;
    makeContainerImage = import ./make-container-image/default.nix args;
    makeDerivation = import ./make-derivation/default.nix args;
    makeDerivationParallel = import ./make-derivation-parallel/default.nix args;
    makeEnvVars = import ./make-env-vars/default.nix args;
    makeEnvVarsForTerraform = import ./make-env-vars-for-terraform/default.nix args;
    makeNodeEnvironment = import ./make-node-environment/default.nix args;
    makePythonEnvironment = import ./make-python-environment/default.nix args;
    makeScript = import ./make-script/default.nix args;
    makeScriptParallel = import ./make-script-parallel/default.nix args;
    makeSearchPaths = import ./make-search-paths/default.nix args;
    makeSecretForAwsFromEnv = import ./make-secret-for-aws-from-env/default.nix args;
    makeSecretForEnvFromSops = import ./make-secret-for-env-from-sops/default.nix args;
    makeSecretForTerraformFromEnv = import ./make-secret-for-terraform-from-env/default.nix args;
    makeTerraformEnvironment = import ./make-terraform-environment/default.nix args;
    makeTemplate = import ./make-template/default.nix args;
    inherit outputs;
    path = rel: projectSrcInStore + rel;
    pathCopy = import ./path-copy/default.nix args projectSrc;
    pathDirs = import ./path-dirs/default.nix args;
    pathMutable = rel: projectSrcMutable + rel;
    pathsMatching = import ./paths-matching/default.nix args;
    securePythonWithBandit = import ./secure-python-with-bandit/default.nix args;
    sortAscii = builtins.sort (a: b: a < b);
    sortAsciiCaseless = builtins.sort (a: b: lib.toLower a < lib.toLower b);
    testTerraform = import ./test-terraform/default.nix args;
    toDerivationName = lib.strings.sanitizeDerivationName;
    toFileJson = import ./to-file-json/default.nix args;
    toFileLst = import ./to-file-lst/default.nix;
  };

  lib = __nixpkgs__.lib;
in
args
