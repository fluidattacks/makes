{ __nixpkgs__
, __toModuleOutputs__
, lintTerraform
, path
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: { authentication, src, version }: {
    name = "/lintTerraform/${name}";
    value = lintTerraform {
      inherit authentication;
      config = builtins.toFile "tflint.hcl" config.lintTerraform.config;
      inherit name;
      src = path src;
      inherit version;
    };
  };
in
{
  options = {
    lintTerraform = {
      config = lib.mkOption {
        default = ''
          config {
            module = true
          }
          plugin "aws" {
            enabled = true
          }
        '';
        type = lib.types.lines;
      };
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            authentication = lib.mkOption {
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
    outputs = __toModuleOutputs__ makeOutput config.lintTerraform.modules;
  };
}
