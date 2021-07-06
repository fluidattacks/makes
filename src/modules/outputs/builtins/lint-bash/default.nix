{ builtinLambdas
, inputs
, lib
, makeScript
, ...
}:
{ config
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
      lintBash = lib.mkIf config.lintBash.enable (makeScript {
        arguments = {
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              (target: "./${target}")
              config.lintBash.targets);
        };
        name = "lint-bash";
        searchPaths = {
          envPaths = [
            inputs.makesPackages.nixpkgs.findutils
            inputs.makesPackages.nixpkgs.shellcheck
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
