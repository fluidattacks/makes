{ buildEnv, buildPythonPackage, pkgDeps, src, }:
let
  metadata = import ./metadata.nix src;
  pkg = import ./pkg { inherit buildPythonPackage metadata pkgDeps src; };
  env = import ./env.nix { inherit buildEnv pkgDeps pkg; };
  checks = import ./check.nix { inherit pkg; };
in {
  inherit pkg env;
  check = checks;
}
