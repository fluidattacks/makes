# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{lintGitMailMap, ...}: {
  config,
  lib,
  ...
}: {
  options = {
    lintGitMailMap = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
    };
  };
  config = {
    outputs = {
      "/lintGitMailMap" =
        lib.mkIf
        (config.lintGitMailMap.enable)
        (lintGitMailMap {
          name = "lint-git-mailmap";
          src = ".";
        });
    };
  };
}
