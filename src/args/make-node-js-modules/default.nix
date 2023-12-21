{
  __nixpkgs__,
  makeDerivation,
  ...
}: {
  name,
  nodeJsVersion,
  packageJson,
  packageLockJson,
  packageOverrides ? {},
}: let
  node2NixLock = makeDerivation {
    builder = ./builder.sh;
    env = {
      envPackageJson = packageJson;
      envPackageLockJson = packageLockJson;
      envNodeJsVersion = nodeJsVersion;
    };
    name = "make-node2nix-lock-for-${name}";
    searchPaths.bin = [
      __nixpkgs__.gnused
      __nixpkgs__.node2nix
    ];
  };
  nodePackages = import node2NixLock {pkgs = __nixpkgs__;};
  nodePackagesOverriden = nodePackages.nodeDependencies.override packageOverrides;
in
  nodePackagesOverriden
