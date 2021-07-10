args:
{ config
, lib
, ...
}:
{
  imports = [
    (import ./builtins args)
    (import ./custom.nix args)
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
    attrs = args.makeDerivation {
      arguments = {
        envList = builtins.toJSON (builtins.attrNames config.outputs);
      };
      builder = ''
        echo "$envList" > "$out"
      '';
      name = "attrs";
    };
  };
}
