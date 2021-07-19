{ __nixpkgs__
, __toModuleOutputs__
, testTerraform
, path
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: { setup, src, version }: {
    name = "/testTerraform/${name}";
    value = testTerraform {
      inherit setup;
      inherit name;
      src = path src;
      inherit version;
    };
  };
in
{
  options = {
    testTerraform = {
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            setup = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.package;
            };
            src = lib.mkOption {
              type = lib.types.str;
            };
            version = lib.mkOption {
              type = lib.types.enum [
                "0.12"
                "0.13"
                "0.14"
                "0.15"
                "0.16"
              ];
            };
          };
        }));
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.testTerraform.modules;
  };
}
