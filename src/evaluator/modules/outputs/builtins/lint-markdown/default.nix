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
        env = {
          envStyle = ./style.rb;
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              path
              config.lintMarkdown.targets);
        };
        name = "lint-markdown";
        searchPaths = {
          bin = [
            __nixpkgs__.mdl
          ];
        };
        builder = ./builder.sh;
      });
    };
  };
}
