{ attrsMapToList
, config
, lib
, attrsOptional
, projectPath
, projectSrc
, toFileJson
, ...
} @ args:
{
  imports = [
    (import ./cache/default.nix args)
    (import ./compute-on-aws-batch/default.nix args)
    (import ./dev/default.nix args)
    (import ./deploy-container-image/default.nix args)
    (import ./deploy-nomad/default.nix args)
    (import ./deploy-terraform/default.nix args)
    (import ./env-vars/default.nix args)
    (import ./env-vars-for-terraform/default.nix args)
    (import ./format-bash/default.nix args)
    (import ./format-markdown/default.nix args)
    (import ./format-nix/default.nix args)
    (import ./format-python/default.nix args)
    (import ./format-scala/default.nix args)
    (import ./format-javascript/default.nix args)
    (import ./format-terraform/default.nix args)
    (import ./hello-world/default.nix args)
    (import ./inputs/default.nix)
    (import ./lint-bash/default.nix args)
    (import ./lint-clojure/default.nix args)
    (import ./lint-git-commit-msg/default.nix args)
    (import ./lint-git-mailmap/default.nix args)
    (import ./lint-markdown/default.nix args)
    (import ./lint-nix/default.nix args)
    (import ./lint-python/default.nix args)
    (import ./lint-terraform/default.nix args)
    (import ./lint-with-ajv/default.nix args)
    (import ./lint-with-lizard/default.nix args)
    (import ./pipelines/default.nix args)
    (import ./secrets-for-aws-from-env/default.nix args)
    (import ./secrets-for-env-from-sops/default.nix args)
    (import ./secrets-for-gpg-from-env/default.nix args)
    (import ./secrets-for-kubernetes-config-from-aws/default.nix args)
    (import ./secrets-for-terraform-from-env/default.nix args)
    (import ./secure-nix-with-vulnix/default.nix args)
    (import ./secure-python-with-bandit/default.nix args)
    (import ./taint-terraform/default.nix args)
    (import ./test-python/default.nix args)
    (import ./test-terraform/default.nix args)
  ];
  options = {
    globalStateDir = lib.mkOption {
      type = lib.types.str;
      default = "$HOME_IMPURE/.makes/state";
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
    extendingMakesDir = lib.mkOption {
      default = "/makes";
      type = lib.types.str;
    };

    config = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
    };
    configAsJson = lib.mkOption {
      type = lib.types.package;
    };
    outputs = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
    };
  };
  config = {
    config = {
      outputs = builtins.attrNames config.outputs;
    };
    configAsJson = toFileJson "config.json" config.config;
    outputs =
      let
        # Load an attr set distributed across many files and directories
        attrsFromPath = path: position:
          builtins.foldl'
            lib.mergeAttrs
            { }
            (lib.lists.flatten
              (attrsMapToList
                (name: type:
                  if type == "directory"
                  then attrsFromPath "${path}/${name}" (position ++ [ name ])
                  else if name == "main.nix"
                  then {
                    "/${builtins.concatStringsSep "/" position}" =
                      (import "${path}/main.nix" args);
                  }
                  else { })
                (builtins.readDir path)));

      in
      (
        attrsOptional
          (builtins.pathExists (projectSrc + config.extendingMakesDir))
          (attrsFromPath (projectPath config.extendingMakesDir) [ ])
      ) //
      ({
        __all__ = toFileJson "all"
          (builtins.removeAttrs config.outputs [ "__all__" ]);
      });
  };
}
