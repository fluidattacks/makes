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
    lintNix = {
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
      "/lintNix" = lib.mkIf config.lintNix.enable (makeDerivation {
        env = {
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              path
              config.lintNix.targets);
        };
        name = "lint-nix";
        searchPaths = {
          bin = [
            __nixpkgs__.nix-linter
          ];
        };
        builder = ./builder.sh;
      });
    };
  };
}
