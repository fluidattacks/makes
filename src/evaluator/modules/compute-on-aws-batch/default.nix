{
  __toModuleOutputs__,
  computeOnAwsBatch,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeOutput = name: config: {
    name = "/computeOnAwsBatch/${name}";
    value = computeOnAwsBatch {
      inherit (config) allowDuplicates;
      inherit (config) attempts;
      inherit (config) attemptDurationSeconds;
      inherit (config) command;
      inherit (config) definition;
      inherit (config) includePositionalArgsInName;
      inherit (config) environment;
      inherit (config) memory;
      inherit (config) queue;
      inherit name;
      inherit (config) setup;
      inherit (config) vcpus;
    };
  };
in {
  options = {
    computeOnAwsBatch = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          allowDuplicates = lib.mkOption {
            default = false;
            type = lib.types.bool;
          };
          attempts = lib.mkOption {
            default = 1;
            type = lib.types.ints.positive;
          };
          attemptDurationSeconds = lib.mkOption {
            type = lib.types.ints.positive;
          };
          command = lib.mkOption {
            type = lib.types.listOf lib.types.str;
          };
          definition = lib.mkOption {
            type = lib.types.str;
          };
          environment = lib.mkOption {
            default = [];
            type = lib.types.listOf lib.types.str;
          };
          includePositionalArgsInName = lib.mkOption {
            default = true;
            type = lib.types.bool;
          };
          memory = lib.mkOption {
            type = lib.types.ints.positive;
          };
          queue = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
          };
          setup = lib.mkOption {
            default = [];
            type = lib.types.listOf lib.types.package;
          };
          vcpus = lib.mkOption {
            type = lib.types.ints.positive;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.computeOnAwsBatch;
  };
}
