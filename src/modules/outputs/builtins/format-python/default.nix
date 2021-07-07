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
    formatPython = {
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
      "/formatPython" = lib.mkIf config.formatPython.enable (makeScript {
        arguments = {
          envSettingsBlack = ./settings-black.toml;
          envSettingsIsort = ./settings-isort.toml;
          envTargets = builtinLambdas.asBashArray
            (builtins.map
              (target: "./${target}")
              config.formatPython.targets);
        };
        name = "format-python";
        searchPaths = {
          envPaths = [
            inputs.makesPackages.nixpkgs.black
            inputs.makesPackages.nixpkgs.git
            inputs.makesPackages.nixpkgs.python38Packages.isort
          ];
          envPython38Paths = [
            inputs.makesPackages.nixpkgs.python38Packages.colorama
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
