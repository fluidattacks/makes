{ asBashArray
, makeDerivation
, path
, makePythonEnvironment
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    lintWithLizard = {
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
      "/lintWithLizard" = lib.mkIf config.lintWithLizard.enable (makeDerivation {
        env = {
          envTargets = asBashArray
            (builtins.map
              path
              config.lintWithLizard.targets);
        };
        name = "lint-with-lizard";
        searchPaths = {
          source = [
            (makePythonEnvironment {
              dependencies = [
                "lizard==1.17.9"
              ];
              name = "lizard";
              python = "3.8";
            })
          ];
        };
        builder = ./builder.sh;
      });
    };
  };
}
