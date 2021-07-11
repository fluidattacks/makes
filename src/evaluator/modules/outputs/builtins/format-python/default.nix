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
            (builtins.map pathImpure config.formatPython.targets);
        };
        name = "format-python";
        searchPaths = {
          bin = [
            __nixpkgs__.black
            __nixpkgs__.git
            __nixpkgs__.python38Packages.isort
          ];
          pythonPackage38 = [
            __nixpkgs__.python38Packages.colorama
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
