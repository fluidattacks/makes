{ __nixpkgs__, __toModuleOutputs__, lintTerraform, projectPath, ... }:
{ config, lib, ... }:
let
  makeOutput = name:
    { setup, src, version, }: {
      name = "/lintTerraform/${name}";
      value = lintTerraform {
        inherit setup;
        config = if config.lintTerraform.config == null then
          ./config.hcl
        else
          projectPath config.lintTerraform.config;
        inherit name;
        src = "." + src;
        inherit version;
      };
    };
in {
  options = {
    lintTerraform = {
      config = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
      };
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
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
    outputs = __toModuleOutputs__ makeOutput config.lintTerraform.modules;
  };
}
