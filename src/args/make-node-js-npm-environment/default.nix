{ __nixpkgs__
, attrsGet
, fromJsonFile
, makeDerivation
, makeNodeJsVersion
, toFileJson
, ...
}:
{ name
, nodeJsVersion
, packageJson
, packageLockJson
}:
let
  nodeJs = makeNodeJsVersion nodeJsVersion;
  packageLock = fromJsonFile packageLockJson;

  collectDependencies = deps:
    builtins.foldl'
      (all: name:
        let
          tarball = __nixpkgs__.fetchurl {
            hash = depAttrs.integrity;
            url = depAttrs.resolved;
          };
          dep = depAttrs // {
            inherit name;
            resolved = tarball;
            resolvedName = "${name}/-/${tarball.name}";
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
    (attrsGet packageLock "dependencies" { }) //
    (attrsGet packageLock "devDependencies" { })
  );
  dependenciesGrouped = __nixpkgs__.lib.lists.groupBy
    (dep: dep.name)
    (dependenciesFlat);

  registryIndexes = builtins.map
    (name: {
      name = "${name}/index.html";
      path = toFileJson "index.json" {
        inherit name;
        versions = builtins.listToAttrs
          (builtins.map
            (versionAttrs: {
              name = versionAttrs.version;
              value = {
                dist.integrity = versionAttrs.integrity;
                dist.tarball = versionAttrs.resolvedName;
              };
            })
            (dependenciesGrouped.${name}));
      };
    })
    (builtins.attrNames dependenciesGrouped);

  registryTarballs = __nixpkgs__.lib.lists.unique (builtins.map
    (dep: { name = dep.resolvedName; path = dep.resolved; })
    (dependenciesFlat));

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
