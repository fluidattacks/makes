{ __nixpkgs__
, lintTerraform
, path
, ...
}:
{ config
, lib
, ...
}:
let
  makeModule = name: { src, version }: {
    name = "/lintTerraform/${name}";
    value = lintTerraform {
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
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
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
    outputs = lib.mkIf config.lintTerraform.enable
      (builtins.foldl'
        (all: one: all // { "${one.name}" = one.value; })
        { }
        (lib.attrsets.mapAttrsToList
          makeModule
          config.lintTerraform.modules));
  };
}
