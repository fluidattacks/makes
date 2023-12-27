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
  packageOverrides ? {},
  searchPaths ? {},
}: let
  node = makeNodeJsVersion nodeJsVersion;
  nodeModules = "${makeNodeJsModules {
    inherit name;
    inherit nodeJsVersion;
    inherit packageJson;
    inherit packageLockJson;
    inherit packageOverrides;
  }}/lib/node_modules";
in
  makeSearchPaths {
    bin = [node];
    nodeBin = [nodeModules];
    nodeModule = [nodeModules];
    source = [(makeSearchPaths searchPaths)];
  }
