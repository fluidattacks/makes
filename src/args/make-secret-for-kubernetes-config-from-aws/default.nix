# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeTemplate,
  ...
}: {
  cluster,
  name,
  region,
}:
makeTemplate {
  name = "make-secret-for-kubernetes-config-from-aws-for-${name}";
  replace = {
    __argCluster__ = cluster;
    __argName__ = name;
    __argRegion__ = region;
  };
  searchPaths.bin = [__nixpkgs__.awscli];
  template = ./template.sh;
}
