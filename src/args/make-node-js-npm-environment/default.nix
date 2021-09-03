{ __nixpkgs__
, attrsGet
, fromJsonFile
, toFileJson
, makeDerivation
, makeNodeJsVersion
, ...
}:
{ name
, nodeJsVersion
, packageJson
, packageLockJson
, ...
}:
let
  nodeJs = makeNodeJsVersion nodeJsVersion;
  packageLock = fromJsonFile packageLockJson;

  collectDependencies = deps:
    builtins.foldl'
      (all: name:
        let
          dep = depAttrs // rec {
            inherit name;
            resolved = __nixpkgs__.fetchurl {
              hash = depAttrs.integrity;
              url = depAttrs.resolved;
            };
            resolvedName = builtins.baseNameOf resolved;
          };
          depAttrs = deps.${name};
          depsOfdep =
            if builtins.hasAttr "dependencies" dep
            then collectDependencies dep.dependencies
            else [ ];
        in
        all ++ depsOfdep ++ [ dep ])
      [ ]
      (builtins.attrNames deps);

  dependenciesFlat = collectDependencies (
    (attrsGet packageLock.dependencies "dependencies" { }) //
    (attrsGet packageLock.dependencies "devDependencies" { })
  );
  dependenciesGrouped = __nixpkgs__.lib.lists.groupBy
    (dep: dep.name)
    (dependenciesFlat);

  registryIndexes = builtins.map
    (name: {
      inherit name;
      path = toFileJson "index.json" {
        inherit name;
        versions = builtins.listToAttrs
          (builtins.map
            (versionAttrs: {
              name = versionAttrs.version;
              value = versionAttrs // {
                dist.integrity = versionAttrs.integrity;
                dist.tarball = versionAttrs.resolvedName;
              };
            })
            (dependenciesGrouped.${name}));
      };
    })
    (builtins.attrNames dependenciesGrouped);

  registryTarballs = builtins.map
    (dep: { name = dep.resolvedName; path = dep.resolved; })
    (dependenciesFlat);

  registry = __nixpkgs__.linkFarm "registry"
    (registryIndexes ++ registryTarballs);
in
makeDerivation {
  builder = ./builder.sh;
  env = {
    envRegistry = registry;
    envPackageJson = packageJson;
    envPackageLockJson = packageLockJson;
  };
  name = "make-node-js-environment-for-${name}";
  searchPaths = {
    bin = [ __nixpkgs__.python39 nodeJs ];
  };
}
