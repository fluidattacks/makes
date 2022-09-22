# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  toBashArray,
  makeScript,
  ...
}: {
  config,
  lib,
  ...
}: {
  options = {
    formatJavaScript = {
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
      "/formatJavaScript" =
        lib.mkIf config.formatJavaScript.enable
        (makeScript {
          replace = {
            __argSettingsPrettier__ = ./settings-prettierrc.yaml;
            __argTargets__ =
              toBashArray
              (builtins.map (rel: "." + rel) config.formatJavaScript.targets);
          };
          name = "format-javascript";
          searchPaths = {
            bin = [
              __nixpkgs__.nodePackages.prettier
            ];
          };
          entrypoint = ./entrypoint.sh;
        });
    };
  };
}
