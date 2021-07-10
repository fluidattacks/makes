{ head }:
{ config
, lib
, ...
}:
let
  args = import ../../args {
    inherit head;
    inputs = config.inputs;
    outputs = config.outputs;
    requiredMakesVersion = config.requiredMakesVersion;
  };
in
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
    attrs = config.inputs.makesPackages.nixpkgs.stdenv.mkDerivation {
      envList = builtins.toJSON (builtins.attrNames config.outputs);
      builder = builtins.toFile "builder" ''
        echo "$envList" > "$out"
      '';
      name = "makes-outputs-list";
    };
  };
}
