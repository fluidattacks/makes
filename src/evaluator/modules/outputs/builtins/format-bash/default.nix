{ __nixpkgs__
, builtinLambdas
, makeScript
, pathImpure
, ...
}:
{ config
, lib
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
      "/formatBash" = lib.mkIf config.formatBash.enable (makeScript {
        arguments = {
          envTargets = builtinLambdas.asBashArray
            (builtins.map pathImpure config.formatBash.targets);
        };
        name = "format-bash";
        searchPaths = {
          envPaths = [
            __nixpkgs__.shfmt
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
