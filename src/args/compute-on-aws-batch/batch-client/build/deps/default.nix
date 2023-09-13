{
  nixpkgs,
  python_version,
}: let
  lib = {
    buildEnv = nixpkgs."${python_version}".buildEnv.override;
    inherit (nixpkgs."${python_version}".pkgs) buildPythonPackage;
    inherit (nixpkgs.python3Packages) fetchPypi;
  };

  utils = import ./override_utils.nix;
  pkgs_overrides = override: python_pkgs: builtins.mapAttrs (_: override python_pkgs) python_pkgs;

  arch-lint = import ./arch_lint.nix {inherit nixpkgs python_version;};
  fa-purity = let
    core = import ./fa_purity.nix {inherit nixpkgs python_version;};
  in {
    "${python_version}" = core;
  };

  layer_1 = python_pkgs:
    python_pkgs
    // {
      arch-lint = arch-lint.pkg;
      fa-purity = fa-purity."${python_version}".pkg;
      mypy-boto3-batch = import ./boto3/batch-stubs.nix {inherit lib python_pkgs;};
      types-boto3 = import ./boto3/stubs.nix {inherit lib python_pkgs;};
    };

  fa_purity_override = python_pkgs: utils.replace_pkg ["fa_purity"] python_pkgs.fa-purity;
  overrides = map pkgs_overrides [
    fa_purity_override
    (_: utils.no_check_override)
  ];

  python_pkgs = utils.compose ([layer_1] ++ overrides) nixpkgs."${python_version}Packages";
in {
  inherit lib python_pkgs;
}
