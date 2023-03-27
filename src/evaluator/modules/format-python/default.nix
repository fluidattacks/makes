{
  __nixpkgs__,
  toBashArray,
  makeScript,
  ...
}: {
  config,
  lib,
  ...
}: {
  options = {
    formatPython = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      targets = lib.mkOption {
        default = ["/"];
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/formatPython" = lib.mkIf config.formatPython.enable (makeScript {
        replace = {
          __argSettingsBlack__ = ./settings-black.toml;
          __argSettingsIsort__ = ./settings-isort.toml;
          __argTargets__ =
            toBashArray
            (builtins.map (rel: "." + rel) config.formatPython.targets);
        };
        name = "format-python";
        searchPaths = {
          bin = [
            __nixpkgs__.black
            __nixpkgs__.git
            __nixpkgs__.python39Packages.isort
          ];
          pythonPackage39 = [
            __nixpkgs__.python39Packages.colorama
          ];
        };
        entrypoint = ./entrypoint.sh;
      });
    };
  };
}
