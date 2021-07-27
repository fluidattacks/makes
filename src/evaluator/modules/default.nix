{ config
, lib
, optionalAttrs
, projectPath
, toFileJson
, ...
} @ args:
{
  imports = [
    (import ./cache.nix args)
    (import ./deploy-container-image/default.nix args)
    (import ./deploy-terraform/default.nix args)
    (import ./env-vars.nix args)
    (import ./env-vars-for-terraform.nix args)
    (import ./format-bash/default.nix args)
    (import ./format-markdown/default.nix args)
    (import ./format-nix/default.nix args)
    (import ./format-python/default.nix args)
    (import ./format-terraform/default.nix args)
    (import ./hello-world/default.nix args)
    (import ./inputs.nix)
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
    (import ./secrets-for-aws-from-env.nix args)
    (import ./secrets-for-env-from-sops.nix args)
    (import ./secrets-for-terraform-from-env.nix args)
    (import ./secure-python-with-bandit/default.nix args)
    (import ./test-terraform/default.nix args)
  ];
  options = {
    attrs = lib.mkOption {
      type = lib.types.package;
    };
    outputs = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
    };
  };
  config = {
    attrs = toFileJson "attrs"
      (builtins.attrNames config.outputs);
    outputs =
      let
        # Load an attr set distributed across many files and directories
        attrsFromPath = path: position:
          builtins.foldl'
            lib.mergeAttrs
            { }
            (lib.lists.flatten
              (lib.attrsets.mapAttrsToList
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

        makes = projectPath "/makes";
      in
      (
        optionalAttrs
          (builtins.pathExists makes)
          (attrsFromPath makes [ ])
      ) //
      ({
        __all__ = toFileJson "all"
          (builtins.removeAttrs config.outputs [ "__all__" ]);
      });
  };
}
