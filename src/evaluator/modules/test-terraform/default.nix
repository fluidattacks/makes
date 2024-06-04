{ __nixpkgs__, __toModuleOutputs__, testTerraform, ... }:
{ config, lib, ... }:
let
  makeOutput = name:
    { debug, setup, src, version, }: {
      name = "/testTerraform/${name}";
      value = testTerraform {
        inherit debug;
        inherit setup;
        inherit name;
        src = "." + src;
        inherit version;
      };
    };
in {
  options = {
    testTerraform = {
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            debug = lib.mkOption {
              default = false;
              type = lib.types.bool;
            };
            setup = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.package;
            };
            src = lib.mkOption { type = lib.types.str; };
            version =
              lib.mkOption { type = lib.types.enum [ "0.14" "0.15" "1.0" ]; };
          };
        }));
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.testTerraform.modules;
  };
}
