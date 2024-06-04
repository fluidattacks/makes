{ makes_inputs, nixpkgs, python_version, src, }:
let
  deps = import ./deps { inherit makes_inputs nixpkgs python_version; };
  pkgDeps = {
    runtime_deps = with deps.python_pkgs; [
      boto3
      click
      fa-purity
      pathos
      mypy-boto3-batch
      types-boto3
    ];
    build_deps = with deps.python_pkgs; [ flit-core ];
    test_deps = with deps.python_pkgs; [ arch-lint mypy pylint pytest ];
  };
  packages = makes_inputs.makePythonPyprojectPackage {
    inherit (deps.lib) buildEnv buildPythonPackage;
    inherit pkgDeps src;
  };
in packages
