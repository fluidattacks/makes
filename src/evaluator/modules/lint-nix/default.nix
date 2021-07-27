{ __nixpkgs__
, asBashArray
, makeDerivation
, projectPath
, ...
}:
{ config
, lib
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
        env = {
          envTargets = asBashArray
            (builtins.map
              projectPath
              config.lintNix.targets);
        };
        name = "lint-nix";
        searchPaths = {
          bin = [
            __nixpkgs__.nix-linter
          ];
        };
        builder = ./builder.sh;
      });
    };
  };
}
