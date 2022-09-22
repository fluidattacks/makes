# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  fromYaml,
  makeTemplate,
  ...
}: let
  testFile = fromYaml (
    builtins.readFile ./test.yaml
  );
  testString = testFile.testTitle;
in
  makeTemplate {
    replace = {
      __argFirst__ = "aaaaaaaaa";
      __argSecond__ = "bbbb";
      __argThird__ = testString;
    };
    name = "test-make-template";
    template = ./template.txt;
  }
