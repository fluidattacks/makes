{ attrsOptional, attrPaths, config, fromJson, lib, projectPath, projectSrc
, toFileJson, ... }@args: {
  imports = [
    (import ./cache/default.nix args)
    (import ./compute-on-aws-batch/default.nix args)
    (import ./dev/default.nix args)
    (import ./deploy-container/default.nix args)
    (import ./deploy-container-manifest/default.nix args)
    (import ./deploy-terraform/default.nix args)
    (import ./dynamodb/default.nix args)
    (import ./env-vars/default.nix args)
    (import ./env-vars-for-terraform/default.nix args)
    (import ./format-bash/default.nix args)
    (import ./format-markdown/default.nix args)
    (import ./format-nix/default.nix args)
    (import ./format-terraform/default.nix args)
    (import ./format-yaml/default.nix args)
    (import ./inputs/default.nix)
    (import ./jobs/default.nix args)
    (import ./lint-bash/default.nix args)
    (import ./lint-git-mailmap/default.nix args)
    (import ./lint-nix/default.nix args)
    (import ./lint-terraform/default.nix args)
    (import ./lint-with-ajv/default.nix args)
    (import ./pipelines/default.nix args)
    (import ./secrets-for-aws-from-env/default.nix args)
    (import ./secrets-for-aws-from-gitlab/default.nix args)
    (import ./secrets-for-env-from-sops/default.nix args)
    (import ./secrets-for-terraform-from-env/default.nix args)
    (import ./test-license/default.nix args)
    (import ./test-terraform/default.nix args)
  ];
  options = {
    globalStateDir = lib.mkOption {
      type = lib.types.str;
      default = "$HOME_IMPURE/.cache/makes/state";
      apply = lib.removeSuffix "/"; # canonicalize
    };
    projectStateDir = lib.mkOption {
      type = lib.types.str;
      default = config.globalStateDir + "/" + config.projectIdentifier;
      apply = lib.removeSuffix "/"; # canonicalize
    };
    projectIdentifier = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    extendingMakesDirs = lib.mkOption {
      default = [ "/makes" ];
      type = lib.types.listOf lib.types.str;
    };

    config = lib.mkOption { type = lib.types.attrsOf lib.types.anything; };
    configAsJson = lib.mkOption { type = lib.types.package; };
    outputs = lib.mkOption { type = lib.types.attrsOf lib.types.package; };
  };
  config = {
    config = { outputs = builtins.attrNames config.outputs; };
    configAsJson = toFileJson "config.json" config.config;
    outputs = let
      # Trivial
      makesDirsNoRoot = lib.remove "/" config.extendingMakesDirs;
      makesDirsToReplace = makesDirsNoRoot ++ [ "/main.nix" ];
      emptyList = builtins.map (_: "") makesDirsToReplace;

      # Load an attr set distributed across many files and directories
      attrs = let
        pathInConfig = dir:
          builtins.any (makesDir: lib.hasInfix makesDir dir)
          config.extendingMakesDirs;
        attrName = dir:
          let
            replaced = builtins.replaceStrings makesDirsToReplace emptyList dir;
          in if replaced != "" then replaced else "/";
      in builtins.foldl' lib.mergeAttrs { } (builtins.map (dir:
        attrsOptional (pathInConfig dir) {
          "${attrName dir}" = import (projectSrc + dir) args;
        }) (fromJson attrPaths).attrs);
    in attrs // {
      __all__ =
        toFileJson "all" (builtins.removeAttrs config.outputs [ "__all__" ]);
    };
  };
}
