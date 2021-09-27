{ __toModuleOutputs__
, projectPath
, testPython
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: args: {
    name = "/testPython/${name}";
    value = testPython {
      inherit name;
      inherit (args) extraFlags;
      inherit (args) python;
      inherit (args) searchPaths;
      src = projectPath args.src;
    };
  };
in
{
  options = {
    testPython = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          extraFlags = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.str;
          };
          python = lib.mkOption {
            type = lib.types.enum [ "3.6" "3.7" "3.8" "3.9" ];
          };
          searchPaths = lib.mkOption {
            default = { };
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
