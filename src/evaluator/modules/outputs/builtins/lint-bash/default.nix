{ __nixpkgs__
, builtinLambdas
, makeDerivation
, path
, ...
}:
{ config
, lib
, ...
}:
{
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
        arguments = {
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              path
              config.lintBash.targets);
        };
        name = "lint-bash";
        searchPaths = {
          envPaths = [
            __nixpkgs__.findutils
            __nixpkgs__.shellcheck
          ];
        };
        builder = ./builder.sh;
      });
    };
  };
}
