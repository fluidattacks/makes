# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{formatBash, ...}: {
  config,
  lib,
  ...
}: {
  options = {
    formatBash = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      targets = lib.mkOption {
        default = ["/"];
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    outputs = {
      "/formatBash" = lib.mkIf config.formatBash.enable (formatBash {
        name = "builtin";
        targets = builtins.map (rel: "." + rel) config.formatBash.targets;
      });
    };
  };
}
