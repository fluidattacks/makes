# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeNodeJsModules,
  makeNodeJsVersion,
  makeSearchPaths,
  ...
}: {
  name,
  nodeJsVersion,
  packageJson,
  packageLockJson,
  searchPaths ? {},
  shouldIgnoreScripts ? false,
}: let
  node = makeNodeJsVersion nodeJsVersion;
  nodeModules = makeNodeJsModules {
    inherit name;
    inherit nodeJsVersion;
    inherit packageJson;
    inherit packageLockJson;
    inherit searchPaths;
    inherit shouldIgnoreScripts;
  };
in
  makeSearchPaths {
    bin = [node];
    nodeBin = [nodeModules];
    nodeModule = [nodeModules];
    source = [(makeSearchPaths searchPaths)];
  }
