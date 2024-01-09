{
  __toModuleOutputs__,
  projectPath,
  testPython,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeOutput = name: args: {
    name = "/testPython/${name}";
    value = testPython {
      inherit name;
      inherit (args) extraSrcs;
      inherit (args) extraFlags;
      project = projectPath "/";
      inherit (args) searchPaths;
      inherit (args) src;
    };
  };
in {
  options = {
    testPython = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          extraSrcs = lib.mkOption {
            default = {};
            type = lib.types.attrsOf lib.types.package;
          };
          extraFlags = lib.mkOption {
            default = [];
            type = lib.types.listOf lib.types.str;
          };
          searchPaths = lib.mkOption {
            default = {};
            type = lib.types.attrs;
          };
          src = lib.mkOption {
            type = lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.testPython;
  };
}
