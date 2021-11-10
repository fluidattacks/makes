# Arguments that can be used outside of a Makes project
# and therefore are agnostic to the framework.
{ stateDirs ? {
    global = "$HOME_IMPURE/.makes/state";
    project = "$HOME_IMPURE/.makes/state/__default__";
  }
, system ? builtins.currentSystem
}:
let
  args = {
    __nixpkgs__ = import sources.nixpkgs { inherit system; };
    __nixpkgsSrc__ = sources.nixpkgs;
    __shellCommands__ = ./shell-commands/template.sh;
    __shellOptions__ = ./shell-options/template.sh;
    __stateDirs__ = stateDirs;
    __system__ = system;
    __toModuleOutputs__ = import ./to-module-outputs/default.nix args;
    asContent = import ./as-content/default.nix;
    attrsGet = import ./attrs-get/default.nix;
    attrsMapToList = lib.mapAttrsToList;
    attrsMerge = builtins.foldl' lib.recursiveUpdate { };
    attrsOptional = lib.optionalAttrs;
    calculateCvss3 = import ./calculate-cvss-3/default.nix args;
    computeOnAwsBatch = import ./compute-on-aws-batch/default.nix args;
    deployContainerImage = import ./deploy-container-image/default.nix args;
    deployNomad = import ./deploy-nomad/default.nix args;
    deployTerraform = import ./deploy-terraform/default.nix args;
    escapeShellArg = lib.strings.escapeShellArg;
    escapeShellArgs = lib.strings.escapeShellArgs;
    fakeSha256 = lib.fakeSha256;
    fetchArchive = import ./fetch-archive/default.nix args;
    fetchGithub = import ./fetch-github/default.nix args;
    fetchGitlab = import ./fetch-gitlab/default.nix args;
    fetchNixpkgs = import ./fetch-nixpkgs/default.nix args;
    fetchRubyGem = import ./fetch-rubygem/default.nix args;
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
    gitlabCi = import ./gitlab-ci/default.nix;
    hasPrefix = lib.strings.hasPrefix;
    hasSuffix = lib.strings.hasSuffix;
    isDarwin = args.__nixpkgs__.stdenv.isDarwin;
    isLinux = args.__nixpkgs__.stdenv.isLinux;
    libGit = import ./lib-git/default.nix args;
    listOptional = lib.lists.optional;
    lintClojure = import ./lint-clojure/default.nix args;
    lintGitCommitMsg = import ./lint-git-commit-msg/default.nix args;
    lintGitMailMap = import ./lint-git-mailmap/default.nix args;
    lintMarkdown = import ./lint-markdown/default.nix args;
    lintPython = import ./lint-python/default.nix args;
    lintPythonImports = import ./lint-python-imports/default.nix args;
    lintTerraform = import ./lint-terraform/default.nix args;
    lintWithAjv = import ./lint-with-ajv/default.nix args;
    lintWithLizard = import ./lint-with-lizard/default.nix args;
    listFilesRecursive = lib.filesystem.listFilesRecursive;
    makeContainerImage = import ./make-container-image/default.nix args;
    makeDerivation = import ./make-derivation/default.nix args;
    makeDerivationParallel = import ./make-derivation-parallel/default.nix args;
    makeDynamoDb = import ./make-dynamodb/default.nix args;
    makeEnvVars = import ./make-env-vars/default.nix args;
    makeEnvVarsForTerraform = import ./make-env-vars-for-terraform/default.nix args;
    makeNodeJsEnvironment = import ./make-node-js-environment/default.nix args;
    makeNodeJsModules = import ./make-node-js-modules/default.nix args;
    makeNodeJsVersion = import ./make-node-js-version/default.nix args;
    makeNomadEnvironment = import ./make-nomad-environment/default.nix args;
    makePythonPypiEnvironment = import ./make-python-pypi-environment/default.nix args;
    makePythonVersion = import ./make-python-version/default.nix args;
    makeRubyGemsEnvironment = import ./make-ruby-gems-environment/default.nix args;
    makeRubyGemsInstall = import ./make-ruby-gems-install/default.nix args;
    makeRubyVersion = import ./make-ruby-version/default.nix args;
    makeScript = import ./make-script/default.nix args;
    makeScriptParallel = import ./make-script-parallel/default.nix args;
    makeSearchPaths = import ./make-search-paths/default.nix args;
    makeSecretForAwsFromEnv = import ./make-secret-for-aws-from-env/default.nix args;
    makeSecretForEnvFromSops = import ./make-secret-for-env-from-sops/default.nix args;
    makeSecretForGpgFromEnv = import ./make-secret-for-gpg-from-env/default.nix args;
    makeSecretForKubernetesConfigFromAws = import ./make-secret-for-kubernetes-config-from-aws/default.nix args;
    makeSecretForNomadFromEnv = import ./make-secret-for-nomad-from-env/default.nix args;
    makeSecretForTerraformFromEnv = import ./make-secret-for-terraform-from-env/default.nix args;
    makeSslCertificate = import ./make-ssl-certificate/default.nix args;
    makeTerraformEnvironment = import ./make-terraform-environment/default.nix args;
    makeTemplate = import ./make-template/default.nix args;
    managePorts = import ./manage-ports/default.nix args;
    patchShebangs = import ./patch-shebangs/default.nix args;
    removePrefix = lib.removePrefix;
    secureNixWithVulnix = import ./secure-nix-with-vulnix/default.nix args;
    securePythonWithBandit = import ./secure-python-with-bandit/default.nix args;
    sortAscii = builtins.sort (a: b: a < b);
    sortAsciiCaseless = builtins.sort (a: b: lib.toLower a < lib.toLower b);
    stringCapitalize = import ./string-capitalize/default.nix args;
    taintTerraform = import ./taint-terraform/default.nix args;
    testTerraform = import ./test-terraform/default.nix args;
    testPython = import ./test-python/default.nix args;
    toDerivationName = lib.strings.sanitizeDerivationName;
    toBashArray = import ./to-bash-array/default.nix args;
    toBashMap = import ./to-bash-map/default.nix args;
    toFileJson = import ./to-file-json/default.nix args;
    toFileToml = import ./to-file-toml/default.nix args;
    toFileYaml = import ./to-file-yaml/default.nix args;
    toFileJsonFromFileYaml = import ./to-file-json-from-file-yaml/default.nix args;
    toFileLst = import ./to-file-lst/default.nix;
  };

  lib = args.__nixpkgs__.lib;

  sources = import ../nix/sources.nix;
in
assert args.isDarwin || args.isLinux;
args
