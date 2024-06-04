{ __nixpkgs__, toBashArray, makeDerivation, projectPath, ... }:
{ config, lib, ... }: {
  options = {
    lintBash = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      targets = lib.mkOption {
        default = [ "/" ];
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/lintBash" = lib.mkIf config.lintBash.enable (makeDerivation {
        env = {
          envTargets =
            toBashArray (builtins.map projectPath config.lintBash.targets);
        };
        name = "lint-bash";
        searchPaths = {
          bin = [ __nixpkgs__.findutils __nixpkgs__.shellcheck ];
        };
        builder = ./builder.sh;
      });
    };
  };
}
