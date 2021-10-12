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
    name = "/deployNomad/${namespace}/${name}";
    value = deployNomad {
      inherit setup;
      inherit name;
      src = "." + src;
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
  };
in
{
  options = {
    deployNomadJobs = {
      jobs = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            setup = setupOpt;
            src = lib.mkOption {
              type = lib.types.str;
            };
            namespace = lib.mkOption {
              type = lib.types.str;
            };
            version = versionOpt;
          };
        }));
      };
    };
    deployNomadNamespaces = {
      namespaces = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (lib.types.submodule (_: {
          options = {
            setup = setupOpt;
            jobs = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
            };
            version = versionOpt;
          };
        }));
      };
    };
  };
  config = {
    outputs = (
      lib.mapAttrs
        (n: v:
          __toModuleOutputs__ makeOutput (v.jobs // {
            setup = v.setup;
            version = v.version;
            namespacn = n;
          })
        )
        config.deployNomadNamespaces.namespaces
    ) // (
      __toModuleOutputs__ makeOutput config.deployNomadJobs.jobs
    );
  };
}
