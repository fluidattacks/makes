{ buildEnv, pkgDeps, pkg, }:
let
  build_env = extraLibs:
    buildEnv {
      inherit extraLibs;
      ignoreCollisions = false;
    };
in {
  runtime = build_env [ pkg ];
  dev = build_env (pkgDeps.runtime_deps ++ pkgDeps.test_deps);
}
