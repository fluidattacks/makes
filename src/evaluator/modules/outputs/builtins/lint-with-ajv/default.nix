{ __toModuleOutputs__
, lintWithAjv
, pathCopy
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: { schema, targets }: {
    name = "/lintWithAjv/${name}";
    value = lintWithAjv {
      inherit name;
      schema = pathCopy schema;
      targets = builtins.map pathCopy targets;
    };
  };
in
{
  options = {
    lintWithAjv = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          schema = lib.mkOption {
            type = lib.types.str;
          };
          targets = lib.mkOption {
            type = lib.types.listOf lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.lintWithAjv;
  };
}
