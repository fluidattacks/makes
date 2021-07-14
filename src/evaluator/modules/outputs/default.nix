{ toJSONFile
, ...
} @ args:
{ config
, lib
, ...
}:
{
  imports = [
    (import ./builtins args)
    (import ./extended args)
  ];
  options = {
    attrs = lib.mkOption {
      type = lib.types.package;
    };
    outputs = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
    };
  };
  config = lib.mkIf (config.assertionsPassed) {
    attrs = toJSONFile "attrs.json" (builtins.attrNames config.outputs);
  };
}
