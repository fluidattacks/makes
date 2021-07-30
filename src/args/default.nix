{ __nixpkgs__
, projectSrc
, projectSrcMutable
, inputs
, outputs
}:
let
  args = {
    inherit __nixpkgs__;
    __shellCommands__ = ./shell-commands/template.sh;
    __shellOptions__ = ./shell-options/template.sh;
    __toModuleOutputs__ = import ./to-module-outputs/default.nix args;
    toBashArray = import ./to-bash-array/default.nix args;
    asBashMap = import ./as-bash-map/default.nix args;
    asContent = import ./as-content/default.nix;
    calculateCvss3 = import ./calculate-cvss-3/default.nix args;
    deployContainerImage = import ./deploy-container-image/default.nix args;
    deployTerraform = import ./deploy-terraform/default.nix args;
    escapeShellArg = lib.strings.escapeShellArg;
    escapeShellArgs = lib.strings.escapeShellArgs;
    fakeSha256 = lib.fakeSha256;
    fetchGithub = import ./fetch-github/default.nix args;
    fetchNixpkgs = import ./fetch-nixpkgs/default.nix args;
    fetchUrl = import ./fetch-url/default.nix args;
    fetchZip = import ./fetch-zip/default.nix args;
    filterAttrs = lib.filterAttrs;
    flatten = lib.lists.flatten;
    formatBash = import ./format-bash/default.nix args;
    formatTerraform = import ./format-terraform/default.nix args;
    fromJson = builtins.fromJSON;
    fromYaml = import ./from-yaml/default.nix args;
    getAttr = import ./get-attr/default.nix;
    hasPrefix = lib.strings.hasPrefix;
    inherit inputs;
    lintClojure = import ./lint-clojure/default.nix args;
    lintGitCommitMsg = import ./lint-git-commit-msg/default.nix args;
    lintGitMailMap = import ./lint-git-mailmap/default.nix args;
    lintMarkdown = import ./lint-markdown/default.nix args;
    lintTerraform = import ./lint-terraform/default.nix args;
    lintWithAjv = import ./lint-with-ajv/default.nix args;
    lintWithLizard = import ./lint-with-lizard/default.nix args;
    listFilesRecursive = lib.filesystem.listFilesRecursive;
    makeContainerImage = import ./make-container-image/default.nix args;
    makeDerivation = import ./make-derivation/default.nix args;
    makeDerivationParallel = import ./make-derivation-parallel/default.nix args;
    makeEnvVars = import ./make-env-vars/default.nix args;
    makeEnvVarsForTerraform = import ./make-env-vars-for-terraform/default.nix args;
    makeNodeJsEnvironment = import ./make-node-js-environment/default.nix args;
    makeNodeJsModules = import ./make-node-js-modules/default.nix args;
    makeNodeJsVersion = import ./make-node-js-version/default.nix args;
    makePythonEnvironment = import ./make-python-environment/default.nix args;
    makeScript = import ./make-script/default.nix args;
    makeScriptParallel = import ./make-script-parallel/default.nix args;
    makeSearchPaths = import ./make-search-paths/default.nix args;
    makeSecretForAwsFromEnv = import ./make-secret-for-aws-from-env/default.nix args;
    makeSecretForEnvFromSops = import ./make-secret-for-env-from-sops/default.nix args;
    makeSecretForTerraformFromEnv = import ./make-secret-for-terraform-from-env/default.nix args;
    makeTerraformEnvironment = import ./make-terraform-environment/default.nix args;
    makeTemplate = import ./make-template/default.nix args;
    mapAttrsToList = lib.mapAttrsToList;
    optionalAttrs = lib.optionalAttrs;
    inherit outputs;
    inherit projectSrc;
    projectPath = import ./project-path/default.nix args;
    projectPathLsDirs = import ./project-path-ls-dirs/default.nix args;
    projectPathMutable = rel: projectSrcMutable + rel;
    projectPathsMatching = import ./project-paths-matching/default.nix args;
    projectSrcInStore = builtins.path { name = "head"; path = projectSrc; };
    inherit projectSrcMutable;
    removePrefix = lib.removePrefix;
    securePythonWithBandit = import ./secure-python-with-bandit/default.nix args;
    sortAscii = builtins.sort (a: b: a < b);
    sortAsciiCaseless = builtins.sort (a: b: lib.toLower a < lib.toLower b);
    testTerraform = import ./test-terraform/default.nix args;
    toDerivationName = lib.strings.sanitizeDerivationName;
    toFileJson = import ./to-file-json/default.nix args;
    toFileJsonFromFileYaml = import ./to-file-json-from-file-yaml/default.nix args;
    toFileLst = import ./to-file-lst/default.nix;
  };

  lib = __nixpkgs__.lib;
in
args
