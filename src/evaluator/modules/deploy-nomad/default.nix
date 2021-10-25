{ __nixpkgs__
, __toModuleOutputs__
, deployNomad
, attrsMerge
, attrsMapToList
, ...
}:
{ config
, lib
, ...
}:
let
  makeNamespaceOutput = namespace: { setup, jobs, version }:
    attrsMapToList makeJobOutput (lib.mapAttrs
      (_: src: {
        inherit setup;
        inherit version;
        inherit namespace;
        inherit src;
      })
      jobs);
  makeJobOutput = name: { setup, src, namespace, version }: {
    name = "/deployNomad/${namespace}/${name}";
    value = deployNomad {
      inherit setup;
      inherit name;
      inherit src;
      inherit namespace;
      inherit version;
    };
  };
  setupOpt = lib.mkOption {
    default = [ ];
    type = lib.types.listOf lib.types.package;
  };
  versionOpt = lib.mkOption {
    type = lib.types.enum [
      "1.0"
      "1.1"
    ];
    default = "1.1";
  };
in
{
  options = {
    deployNomad = {
      jobs = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            setup = setupOpt;
            src = lib.mkOption {
              type = lib.types.str;
            };
            namespace = lib.mkOption {
              type = lib.types.path;
            };
            version = versionOpt;
          };
        }));
      };
      namespaces = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            setup = setupOpt;
            jobs = lib.mkOption {
              type = lib.types.attrsOf lib.types.path;
            };
            version = versionOpt;
          };
        }));
      };
    };
  };
  config = {
    outputs = attrsMerge [
      (__toModuleOutputs__ makeNamespaceOutput config.deployNomad.namespaces)
      (__toModuleOutputs__ makeJobOutput config.deployNomad.jobs)
    ];
  };
}
