# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  makePythonPypiEnvironment,
  makeSearchPaths,
  makeScript,
  toBashArray,
  toBashMap,
  ...
}: {
  extraFlags,
  extraSrcs,
  name,
  project,
  python,
  searchPaths,
  src,
}: let
  pythonPypiEnvironment = makePythonPypiEnvironment {
    inherit name;
    sourcesYaml =
      {
        "3.7" = ./pypi-sources-3.7.yaml;
        "3.8" = ./pypi-sources-3.8.yaml;
        "3.9" = ./pypi-sources-3.9.yaml;
        "3.10" = ./pypi-sources-3.10.yaml;
      }
      .${python};
  };
in
  makeScript {
    name = "test-python-for-${name}";
    replace = {
      __argExtraFlags__ = toBashArray extraFlags;
      __argExtraSrcs__ = toBashMap extraSrcs;
      __argProject__ = project;
      __argSrc__ = src;
    };
    entrypoint = ./entrypoint.sh;
    searchPaths = {
      source = [pythonPypiEnvironment (makeSearchPaths searchPaths)];
    };
  }
