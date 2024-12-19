# Arguments that can be used outside of a Makes project
# and therefore are agnostic to the framework.
{ stateDirs ? {
  global = "$HOME_IMPURE/.cache/makes/state";
  project = "$HOME_IMPURE/.cache/makes/state/__default__";
}, system ? builtins.currentSystem, }:
let
  fix' = __unfix__: let x = __unfix__ x // { inherit __unfix__; }; in x;
  sources = import ../nix/sources.nix;
  args = fix' (self:
    let
      __nixpkgs__ = import sources.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      inherit __nixpkgs__;
      __nixpkgsSrc__ = sources.nixpkgs;
      __shellCommands__ = ./shell-commands/template.sh;
      __shellOptions__ = ./shell-options/template.sh;
      __stateDirs__ = stateDirs;
      __system__ = system;
      __toModuleOutputs__ = import ./to-module-outputs/default.nix self;
      asContent = import ./as-content/default.nix;
      attrsGet = import ./attrs-get/default.nix;
      attrsMapToList = __nixpkgs__.lib.mapAttrsToList;
      attrsMerge = builtins.foldl' __nixpkgs__.lib.recursiveUpdate { };
      attrsOptional = __nixpkgs__.lib.optionalAttrs;
      computeOnAwsBatch = import ./compute-on-aws-batch/default.nix self;
      deployContainer = import ./deploy-container/default.nix self;
      deployContainerManifest =
        import ./deploy-container-manifest/default.nix self;
      deployTerraform = import ./deploy-terraform/default.nix self;
      inherit (__nixpkgs__.lib) fakeSha256;
      fetchArchive = import ./fetch-archive/default.nix self;
      fetchNixpkgs = import ./fetch-nixpkgs/default.nix self;
      fetchRubyGem = import ./fetch-rubygem/default.nix self;
      fetchUrl = import ./fetch-url/default.nix self;
      formatBash = import ./format-bash/default.nix self;
      formatNix = import ./format-nix/default.nix self;
      formatTerraform = import ./format-terraform/default.nix self;
      formatYaml = import ./format-yaml/default.nix self;
      fromJson = builtins.fromJSON;
      fromJsonFile = path: builtins.fromJSON (builtins.readFile path);
      fromYaml = import ./from-yaml/default.nix self;
      fromYamlFile = path: self.fromYaml (builtins.readFile path);
      gitlabCi = import ./gitlab-ci/default.nix;
      inherit (__nixpkgs__.lib.strings) hasPrefix;
      inherit (__nixpkgs__.lib.strings) hasSuffix;
      inherit (__nixpkgs__.stdenv) isDarwin;
      inherit (__nixpkgs__.stdenv) isLinux;
      libGit = import ./lib-git/default.nix self;
      lintGitMailMap = import ./lint-git-mailmap/default.nix self;
      lintNix = import ./lint-nix/default.nix self;
      lintTerraform = import ./lint-terraform/default.nix self;
      lintWithAjv = import ./lint-with-ajv/default.nix self;
      inherit (__nixpkgs__.lib.filesystem) listFilesRecursive;
      makeContainerImage = import ./make-container-image/default.nix self;
      makeDerivation = import ./make-derivation/default.nix self;
      makeDynamoDb = import ./make-dynamodb/default.nix self;
      makeEnvVars = import ./make-env-vars/default.nix self;
      makeEnvVarsForTerraform =
        import ./make-env-vars-for-terraform/default.nix self;
      makePythonEnvironment = import ./make-python-environment/default.nix self;
      makePythonPoetryEnvironment =
        import ./make-python-poetry-environment/default.nix self;
      makePythonPyprojectPackage =
        import ./make-python-pyproject-package/default.nix;
      makePythonVscodeSettings =
        import ./make-python-vscode-settings/default.nix self;
      makeRubyGemsEnvironment =
        import ./make-ruby-gems-environment/default.nix self;
      makeRubyGemsInstall = import ./make-ruby-gems-install/default.nix self;
      makeScript = import ./make-script/default.nix self;
      makeSearchPaths = import ./make-search-paths/default.nix self;
      makeSecretForAwsFromEnv =
        import ./make-secret-for-aws-from-env/default.nix self;
      makeSecretForAwsFromGitlab =
        import ./make-secret-for-aws-from-gitlab/default.nix self;
      makeSecretForEnvFromSops =
        import ./make-secret-for-env-from-sops/default.nix self;
      makeSecretForTerraformFromEnv =
        import ./make-secret-for-terraform-from-env/default.nix self;
      makeTerraformEnvironment =
        import ./make-terraform-environment/default.nix self;
      makeSslCertificate = import ./make-ssl-certificate/default.nix self;
      makeTemplate = import ./make-template/default.nix self;
      managePorts = import ./manage-ports/default.nix self;
      patchShebangs = import ./patch-shebangs/default.nix self;
      pythonOverrideUtils = import ./python-override-utils/default.nix;
      inherit (__nixpkgs__.lib) removePrefix;
      stringCapitalize = import ./string-capitalize/default.nix self;
      sublist = import ./sublist/default.nix self;
      testLicense = import ./test-license/default.nix self;
      testTerraform = import ./test-terraform/default.nix self;
      toDerivationName = __nixpkgs__.lib.strings.sanitizeDerivationName;
      toBashArray = import ./to-bash-array/default.nix self;
      toBashMap = import ./to-bash-map/default.nix self;
      toFileJson = import ./to-file-json/default.nix self;
      toFileToml = import ./to-file-toml/default.nix self;
      toFileYaml = import ./to-file-yaml/default.nix self;
      toFileJsonFromFileYaml =
        import ./to-file-json-from-file-yaml/default.nix self;
      toFileLst = import ./to-file-lst/default.nix;
    });
in assert args.isDarwin || args.isLinux; args
