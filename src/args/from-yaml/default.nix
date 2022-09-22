# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  fromJson,
  toFileJsonFromFileYaml,
  ...
}: expr:
fromJson
(builtins.readFile
  (toFileJsonFromFileYaml
    (builtins.toFile "src" expr)))
