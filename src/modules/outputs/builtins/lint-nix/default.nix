{ builtinLambdas
, inputs
, lib
, makeDerivation
, path
, ...
}:
{ config
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
        arguments = {
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              path
              config.lintNix.targets);
        };
        name = "lint-nix";
        searchPaths = {
          envPaths = [
            inputs.makesPackages.nixpkgs.nix-linter
          ];
        };
        builder = ./builder.sh;
      });
    };
  };
}
