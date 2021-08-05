{ __nixpkgs__
, __toModuleOutputs__
, projectPath
, taintTerraform
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: { resources, setup, src, version }: {
    name = "/taintTerraform/${name}";
    value = taintTerraform {
      inherit name;
      inherit setup;
      src = projectPath src;
      inherit resources;
      inherit version;
    };
  };
in
{
  options = {
    taintTerraform = {
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            resources = lib.mkOption {
              type = lib.types.listOf lib.types.str;
            };
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
    outputs = __toModuleOutputs__ makeOutput config.taintTerraform.modules;
  };
}
