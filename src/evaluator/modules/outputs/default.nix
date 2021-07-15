{ toFileJson
, ...
} @ args:
{ config
, lib
, ...
}:
{
  imports = [
    (import ./builtins/default.nix args)
    (import ./extended/default.nix args)
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
    attrs = toFileJson "attrs.json" (builtins.attrNames config.outputs);
  };
}
