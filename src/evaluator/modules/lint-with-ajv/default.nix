{ __nixpkgs__, __toModuleOutputs__, attrsOptional, isLinux, lintWithAjv
, projectPath, ... }:
{ config, lib, ... }:
let
  makeOutput = name:
    { schema, targets, }: {
      name = "/lintWithAjv/${name}";
      value = lintWithAjv {
        inherit name;
        schema = projectPath schema;
        targets = builtins.map projectPath targets;
      };
    };
in {
  options = {
    lintWithAjv = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          schema = lib.mkOption { type = lib.types.str; };
          targets = lib.mkOption { type = lib.types.listOf lib.types.str; };
        };
      }));
    };
  };
  config = attrsOptional isLinux {
    outputs = __toModuleOutputs__ makeOutput config.lintWithAjv;
  };
}
