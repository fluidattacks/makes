# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __toModuleOutputs__,
  lintClojure,
  projectPath,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeOutput = name: targets: {
    name = "/lintClojure/${name}";
    value = lintClojure {
      inherit name;
      targets = builtins.map projectPath targets;
    };
  };
in {
  options = {
    lintClojure = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeOutput config.lintClojure;
  };
}
