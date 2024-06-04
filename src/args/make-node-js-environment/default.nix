{ __nixpkgs__, makeNodeJsModules, makeSearchPaths, ... }:
{ name, nodeJsVersion, packageJson, packageLockJson, packageOverrides ? { }
, searchPaths ? { }, }:
let
  node = if nodeJsVersion == "18" then
    __nixpkgs__.nodejs_18
  else if nodeJsVersion == "20" then
    __nixpkgs__.nodejs_20
  else if nodeJsVersion == "21" then
    __nixpkgs__.nodejs_21
  else
    abort "Supported node versions are: 18, 20 and 21";

  nodeModules = "${
      makeNodeJsModules {
        inherit name;
        inherit nodeJsVersion;
        inherit packageJson;
        inherit packageLockJson;
        inherit packageOverrides;
      }
    }/lib/node_modules";
in makeSearchPaths {
  bin = [ node ];
  nodeBin = [ nodeModules ];
  nodeModule = [ nodeModules ];
  source = [ (makeSearchPaths searchPaths) ];
}
