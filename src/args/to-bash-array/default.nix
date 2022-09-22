# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  escapeShellArgs,
  makeTemplate,
  ...
}: list:
makeTemplate {
  replace = {
    __argArray__ = escapeShellArgs list;
  };
  name = "to-bash-array";
  template = ./template.sh;
}
