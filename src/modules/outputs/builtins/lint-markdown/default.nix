{ builtinLambdas
, inputs
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
    lintMarkdown = {
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
      "/lintMarkdown" = lib.mkIf config.lintMarkdown.enable (makeDerivation {
        arguments = {
          envStyle = path /src/modules/outputs/builtins/lint-markdown/style.rb;
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              path
              config.lintMarkdown.targets);
        };
        name = "lint-markdown";
        searchPaths = {
          envPaths = [
            inputs.makesPackages.nixpkgs.mdl
          ];
        };
        builder = ./builder.sh;
      });
    };
  };
}
