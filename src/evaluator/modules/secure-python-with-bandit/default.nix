# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __toModuleOutputs__,
  projectPath,
  securePythonWithBandit,
  ...
}: {
  config,
  lib,
  ...
}: let
  makeModule = name: {
    python,
    target,
  }: {
    name = "/securePythonWithBandit/${name}";
    value = securePythonWithBandit {
      inherit name;
      inherit python;
      target = projectPath target;
    };
  };
in {
  options = {
    securePythonWithBandit = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          python = lib.mkOption {
            type = lib.types.enum ["3.8" "3.9" "3.10"];
          };
          target = lib.mkOption {
            type = lib.types.str;
          };
        };
      }));
    };
  };
  config = {
    outputs = __toModuleOutputs__ makeModule config.securePythonWithBandit;
  };
}
