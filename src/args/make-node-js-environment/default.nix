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
}:
let
  node = makeNodeJsVersion nodeJsVersion;
  nodeModules = makeNodeJsModules {
    inherit name;
    inherit nodeJsVersion;
    inherit packageJson;
    inherit packageLockJson;
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
}
