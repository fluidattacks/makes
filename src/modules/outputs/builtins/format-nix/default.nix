{ builtinLambdas
, inputs
, makeScript
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    formatNix = {
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
      "/formatNix" = lib.mkIf config.formatNix.enable (makeScript {
        arguments = {
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              (target: "./${target}")
              config.formatNix.targets);
        };
        name = "format-nix";
        searchPaths = {
          envPaths = [
            inputs.makesPackages.nixpkgs.nixpkgs-fmt
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
