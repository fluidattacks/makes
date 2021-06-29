{ builtinLambdas
, inputs
, lib
, makeEntrypoint
, ...
}:
{ config
, ...
}:
{
  options = {
    formatBash = {
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
      formatBash = lib.mkIf config.formatBash.enable (makeEntrypoint {
        arguments = {
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              (target: "./${target}")
              config.formatBash.targets);
        };
        name = "format-bash";
        searchPaths = {
          envPaths = [
            inputs.makesPackages.nixpkgs.shfmt
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
