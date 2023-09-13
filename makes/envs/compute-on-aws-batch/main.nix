{
  __nixpkgs__,
  makePythonPyprojectPackage,
  makePythonVscodeSettings,
  projectPath,
  ...
}: let
  root = projectPath "/src/args/compute-on-aws-batch/batch-client";
  pkg = import "${root}/entrypoint.nix" {
    inherit makePythonPyprojectPackage;
    nixpkgs = __nixpkgs__;
  };
in
  makePythonVscodeSettings {
    env = pkg.env.dev;
    bins = [];
    name = "makes-batch-client-env-dev";
  }
