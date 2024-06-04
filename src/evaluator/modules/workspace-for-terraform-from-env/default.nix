{ __nixpkgs__, __toModuleOutputs__, makeWorkspaceForTerraformFromEnv, ... }:
{ config, lib, ... }:
let
  makeOutput = name:
    { setup, src, variable, version, }: {
      name = "/workspaceForTerraformFromEnv/${name}";
      value = makeWorkspaceForTerraformFromEnv {
        inherit setup;
        inherit name;
        src = "." + src;
        inherit variable;
        inherit version;
      };
    };
in {
  options = {
    workspaceForTerraformFromEnv = {
      modules = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            setup = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.package;
            };
            src = lib.mkOption { type = lib.types.str; };
            variable = lib.mkOption {
              default = "";
              type = lib.types.str;
            };
            version =
              lib.mkOption { type = lib.types.enum [ "0.14" "0.15" "1.0" ]; };
          };
        }));
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput
      config.workspaceForTerraformFromEnv.modules;
  };
}
