# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __toModuleOutputs__,
  lintMarkdown,
  projectPath,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeOutput = name: {
    config,
    targets,
  }: {
    name = "/lintMarkdown/${name}";
    value = lintMarkdown {
      inherit name;
      config =
        if config == null
        then ./config.rb
        else projectPath config;
      targets = builtins.map projectPath targets;
    };
  };
in {
  options = {
    lintMarkdown = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          config = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.str;
          };
          targets = lib.mkOption {
            type = lib.types.listOf lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.lintMarkdown;
  };
}
