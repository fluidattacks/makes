{ __nixpkgs__
, makeNodeJsModules
, makeNodeJsVersion
, makeSearchPaths
, ...
}:
{ bin ? { }
, name
, nodeJsVersion
, packageJson
, packageLockJson
, searchPaths ? { }
}:
let
  node = makeNodeJsVersion nodeJsVersion;
  nodeModules = makeNodeJsModules {
    inherit name;
    inherit nodeJsVersion;
    inherit packageJson;
    inherit packageLockJson;
    inherit searchPaths;
  };

  dotBin = __nixpkgs__.linkFarm "make-node-js-environment-for-${name}"
    (builtins.map
      (name: { name = ".bin/${name}"; path = "${nodeModules}/${bin.${name}}"; })
      (builtins.attrNames bin));
in
makeSearchPaths {
  bin = [ node ];
  nodeBin = [ dotBin nodeModules ];
  nodeModule = [ nodeModules ];
  source = [ (makeSearchPaths searchPaths) ];
}
