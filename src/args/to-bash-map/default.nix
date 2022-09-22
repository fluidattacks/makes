# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  attrsMapToList,
  makeTemplate,
  escapeShellArg,
  ...
}: attrset:
makeTemplate {
  replace = {
    __argMap__ =
      builtins.toString
      (attrsMapToList
        (name: value: escapeShellArg "[${name}]=${escapeShellArg value}")
        attrset);
  };
  template = ./template.sh;
  name = "as-bash-map";
}
