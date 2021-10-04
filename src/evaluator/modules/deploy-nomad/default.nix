{ __nixpkgs__
, __toModuleOutputs__
, deployNomad
, ...
}:
{ config
, lib
, ...
}:
let
  makeOutput = name: { setup, src, namespace, version }: {
    name = "/deployNomad/${name}";
    value = deployNomad {
      inherit setup;
      inherit name;
      src = "." + src;
      inherit namespace;
      inherit version;
    };
  };
in
{
  options = {
    deployNomad = {
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
            namespace = lib.mkOption {
              type = lib.types.str;
            };
            version = lib.mkOption {
              type = lib.types.enum [
                "1.0"
                "1.1"
              ];
            };
          };
        }));
      };
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.deployNomad.modules;
  };
}
