{
  __toModuleOutputs__,
  formatPython,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeOutput = name: args: {
    name = "/formatPython/${name}";
    value = formatPython {
      inherit name;
      inherit (args) config;
      inherit (args) targets;
    };
  };
in {
  options = {
    formatPython = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          config = {
            black = lib.mkOption {
              default = ./settings-black.toml;
              type = lib.types.path;
            };
            isort = lib.mkOption {
              default = ./settings-isort.toml;
              type = lib.types.path;
            };
          };
          targets = lib.mkOption {
            default = ["/"];
            type = lib.types.listOf lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.formatPython;
  };
}
