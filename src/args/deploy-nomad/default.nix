# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  makeScript,
  makeNomadEnvironment,
  ...
}: {
  setup,
  name,
  version,
  src,
  namespace,
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argSrc__ = src;
    __argNamespace__ = namespace;
  };
  name = "deploy-nomad-for-${name}";
  searchPaths = {
    source =
      [
        (makeNomadEnvironment {
          inherit version;
        })
      ]
      ++ setup;
  };
}
