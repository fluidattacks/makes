# Arguments that can be used outside of a Makes project
# and therefore are agnostic to the framework.
{ __nixpkgs__ ? (import ../nix/packages.nix).nixpkgs
}:
let
  args = {
    inherit __nixpkgs__;
    __shellCommands__ = ./shell-commands/template.sh;
    __shellOptions__ = ./shell-options/template.sh;
    __toModuleOutputs__ = import ./to-module-outputs/default.nix args;
    asContent = import ./as-content/default.nix;
    attrsMapToList = lib.mapAttrsToList;
    attrsMerge = builtins.foldl' lib.recursiveUpdate { };
    attrsOptional = lib.optionalAttrs;
    calculateCvss3 = import ./calculate-cvss-3/default.nix args;
    deployContainerImage = import ./deploy-container-image/default.nix args;
    deployTerraform = import ./deploy-terraform/default.nix args;
    escapeShellArg = lib.strings.escapeShellArg;
    escapeShellArgs = lib.strings.escapeShellArgs;
    fakeSha256 = lib.fakeSha256;
    fetchArchive = import ./fetch-archive/default.nix args;
    fetchGithub = import ./fetch-github/default.nix args;
    fetchNixpkgs = import ./fetch-nixpkgs/default.nix args;
    fetchUrl = import ./fetch-url/default.nix args;
    filterAttrs = lib.filterAttrs;
    flatten = lib.lists.flatten;
    formatBash = import ./format-bash/default.nix args;
    formatTerraform = import ./format-terraform/default.nix args;
    fromJson = builtins.fromJSON;
    fromJsonFile = path: builtins.fromJSON (builtins.readFile path);
    fromToml = builtins.fromTOML;
    fromYaml = import ./from-yaml/default.nix args;
    fromYamlFile = path: args.fromYaml (builtins.readFile path);
    getAttr = import ./get-attr/default.nix;
    gitlabCi = import ./gitlab-ci/default.nix;
    hasPrefix = lib.strings.hasPrefix;
    listOptional = lib.lists.optional;
    lintClojure = import ./lint-clojure/default.nix args;
    lintGitMailMap = import ./lint-git-mailmap/default.nix args;
    lintMarkdown = import ./lint-markdown/default.nix args;
    lintTerraform = import ./lint-terraform/default.nix args;
    lintWithLizard = import ./lint-with-lizard/default.nix args;
    listFilesRecursive = lib.filesystem.listFilesRecursive;
    makeContainerImage = import ./make-container-image/default.nix args;
    makeDerivation = import ./make-derivation/default.nix args;
    makeDerivationParallel = import ./make-derivation-parallel/default.nix args;
    makeEnvVars = import ./make-env-vars/default.nix args;
    makeEnvVarsForTerraform = import ./make-env-vars-for-terraform/default.nix args;
    makePythonPypiEnvironment = import ./make-python-pypi-environment/default.nix args;
    makePythonVersion = import ./make-python-version/default.nix args;
    makeScript = import ./make-script/default.nix args;
    makeScriptParallel = import ./make-script-parallel/default.nix args;
    makeSearchPaths = import ./make-search-paths/default.nix args;
    makeSecretForAwsFromEnv = import ./make-secret-for-aws-from-env/default.nix args;
    makeSecretForEnvFromSops = import ./make-secret-for-env-from-sops/default.nix args;
    makeSecretForKubernetesConfigFromAws = import ./make-secret-for-kubernetes-config-from-aws/default.nix args;
    makeSecretForTerraformFromEnv = import ./make-secret-for-terraform-from-env/default.nix args;
    makeTerraformEnvironment = import ./make-terraform-environment/default.nix args;
    makeTemplate = import ./make-template/default.nix args;
    removePrefix = lib.removePrefix;
    securePythonWithBandit = import ./secure-python-with-bandit/default.nix args;
    sortAscii = builtins.sort (a: b: a < b);
    sortAsciiCaseless = builtins.sort (a: b: lib.toLower a < lib.toLower b);
    taintTerraform = import ./taint-terraform/default.nix args;
    testTerraform = import ./test-terraform/default.nix args;
    toDerivationName = lib.strings.sanitizeDerivationName;
    toBashArray = import ./to-bash-array/default.nix args;
    toBashMap = import ./to-bash-map/default.nix args;
    toFileJson = import ./to-file-json/default.nix args;
    toFileToml = import ./to-file-toml/default.nix args;
    toFileYaml = import ./to-file-yaml/default.nix args;
    toFileJsonFromFileYaml = import ./to-file-json-from-file-yaml/default.nix args;
    toFileLst = import ./to-file-lst/default.nix;
  };

  lib = __nixpkgs__.lib;
in
args
