{ __nixpkgs__
, attrsOptional
, isLinux
, makeNodeJsEnvironment
, makeScript
, projectPathMutable
, toBashArray
, ...
}:
{ config
, lib
, ...
}:
{
  options = {
    formatMarkdown = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      doctocArgs = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
      };
      targets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = attrsOptional isLinux {
    outputs = {
      "/formatMarkdown" = lib.mkIf config.formatMarkdown.enable (makeScript {
        replace = {
          __argDoctocArgs__ = toBashArray
            config.formatMarkdown.doctocArgs;
          __argTargets__ = toBashArray
            (builtins.map projectPathMutable config.formatMarkdown.targets);
        };
        name = "format-markdown";
        searchPaths = {
          bin = [
            __nixpkgs__.git
            __nixpkgs__.gnugrep
            __nixpkgs__.gnused
          ];
          source = [
            (makeNodeJsEnvironment {
              name = "doctoc";
              nodeJsVersion = "16";
              packageJson = ./doctoc/package.json;
              packageLockJson = ./doctoc/package-lock.json;
            })
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
