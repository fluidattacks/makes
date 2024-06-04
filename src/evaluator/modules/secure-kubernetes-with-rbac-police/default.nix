{ __toModuleOutputs__, secureKubernetesWithRbacPolice, ... }:
{ config, lib, ... }:
let
  type = lib.types.submodule (_: {
    options = {
      setup = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
      };
      severity = lib.mkOption {
        default = "Low";
        type = lib.types.str;
      };
    };
  });
  output = name:
    { setup, severity, }: {
      name = "/secureKubernetesWithRbacPolice/${name}";
      value = secureKubernetesWithRbacPolice {
        inherit name;
        inherit setup;
        inherit severity;
      };
    };
in {
  options = {
    secureKubernetesWithRbacPolice = lib.mkOption {
      default = { };
      type = lib.types.attrsOf type;
    };
  };
  config = {
    outputs = __toModuleOutputs__ output config.secureKubernetesWithRbacPolice;
  };
}
