{ __nixpkgs__
, asBashArray
, makeScript
, pathMutable
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
        replace = {
          __argTargets__ = asBashArray
            (builtins.map pathMutable config.formatNix.targets);
        };
        name = "format-nix";
        searchPaths = {
          bin = [
            __nixpkgs__.nixpkgs-fmt
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
