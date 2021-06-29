let
  packages = import ./src/nix/packages.nix;
  src = ./src;
in
packages.nixpkgs.writeShellScriptBin "m" ''
  _EVALUATOR=${src}/evaluator.nix \
  _NIX_BUILD=${packages.nixpkgs.nix}/bin/nix-build \
  _NIX_INSTANTIATE=${packages.nixpkgs.nix}/bin/nix-instantiate \
  LD_LIBRARY_PATH=/not-set \
  PATH=/not-set \
  PYTHONPATH=${src} \
  ${packages.nixpkgs.python3.withPackages (_: [
  ])}/bin/python -m cli "$@"
''
