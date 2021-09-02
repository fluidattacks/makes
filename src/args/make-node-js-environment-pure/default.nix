{ __nixpkgs__
, fromJsonFile
, toFileJson
, makeDerivation
, makeNodeJsVersion
, ...
}:
{ name
, nodeJsVersion
, packageLockJson
, ...
}:
let
  nodeJs = makeNodeJsVersion nodeJsVersion;
  packageLock = fromJsonFile packageLockJson;

  nixifyDependencies = builtins.mapAttrs
    (_: dependencyParams:
      (builtins.removeAttrs dependencyParams [ "resolved" ]) // {
        dependencies =
          if builtins.hasAttr "dependencies" dependencyParams
          then nixifyDependencies dependencyParams.dependencies
          else { };
        version =
          let file = __nixpkgs__.fetchurl {
            hash = dependencyParams.integrity;
            url = dependencyParams.resolved;
          };
          in "file:${file}";
      });

  packageLockNixified = packageLock // {
    dependencies = nixifyDependencies packageLock.dependencies;
  };
in
makeDerivation {
  builder = ./builder.sh;
  env = {
    envPackageLockJson = toFileJson "package-lock.json" packageLockNixified;
  };
  name = "make-node-js-environment-for-${name}";
  searchPaths = {
    bin = [ __nixpkgs__.jq nodeJs ];
  };
}
