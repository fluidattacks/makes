# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{formatNix, ...}: {
  config,
  lib,
  ...
}: {
  options = {
    formatNix = {
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
      "/formatNix" = lib.mkIf config.formatNix.enable (formatNix {
        name = "builtin";
        targets = builtins.map (rel: "." + rel) config.formatNix.targets;
      });
    };
  };
}
