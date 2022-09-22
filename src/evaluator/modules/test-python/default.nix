# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __toModuleOutputs__,
  projectPath,
  testPython,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeOutput = name: args: {
    name = "/testPython/${name}";
    value = testPython {
      inherit name;
      inherit (args) extraSrcs;
      inherit (args) extraFlags;
      project = projectPath "/";
      inherit (args) python;
      inherit (args) searchPaths;
      inherit (args) src;
    };
  };
in {
  options = {
    testPython = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          extraSrcs = lib.mkOption {
            default = {};
            type = lib.types.attrsOf lib.types.package;
          };
          extraFlags = lib.mkOption {
            default = [];
            type = lib.types.listOf lib.types.str;
          };
          python = lib.mkOption {
            type = lib.types.enum ["3.7" "3.8" "3.9" "3.10"];
          };
          searchPaths = lib.mkOption {
            default = {};
            type = lib.types.attrs;
          };
          src = lib.mkOption {
            type = lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.testPython;
  };
}
