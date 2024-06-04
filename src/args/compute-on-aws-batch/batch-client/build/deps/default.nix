{ makes_inputs, nixpkgs, python_version, }:
let
  lib = {
    buildEnv = nixpkgs."${python_version}".buildEnv.override;
    inherit (nixpkgs."${python_version}".pkgs) buildPythonPackage;
    inherit (nixpkgs.python3Packages) fetchPypi;
  };

  utils = makes_inputs.pythonOverrideUtils;

  layer_1 = python_pkgs:
    python_pkgs // {
      arch-lint = let
        result = import ./arch_lint.nix {
          inherit lib makes_inputs nixpkgs python_pkgs python_version;
        };
      in result.pkg;
      mypy-boto3-batch =
        import ./boto3/batch-stubs.nix { inherit lib python_pkgs; };
      types-boto3 = import ./boto3/stubs.nix { inherit lib python_pkgs; };
    };
  layer_2 = python_pkgs:
    python_pkgs // {
      fa-purity = let
        result = import ./fa_purity.nix {
          inherit lib makes_inputs nixpkgs python_pkgs python_version;
        };
      in result.pkg;
    };

  python_pkgs =
    utils.compose [ layer_2 layer_1 ] nixpkgs."${python_version}Packages";
in { inherit lib python_pkgs; }
