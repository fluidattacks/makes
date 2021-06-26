rec {
  makes = {
    # Makes CLI, used for orchestrating the whole thing
    #   Dev with: $(nix-build -A makes.m)/bin/m
    #   Install with: nix-env --install -A makes.m -f .
    #   Run with: m
    m = packages.nixpkgs.writeShellScriptBin "m" ''
      _NIX_INSTANTIATE=${packages.nixpkgs.nix}/bin/nix-instantiate \
      LD_LIBRARY_PATH=/not-set \
      PATH=/not-set \
      PYTHONPATH=${makes.src} \
      ${packages.nixpkgs.python3.withPackages (_: [
        packages.nixpkgs.python3Packages.click
      ])}/bin/python -m cli "$@"
    '';

    # Makes module system evaluator
    module =
      { head # Path to the user's project
      , ...
      }:
      let
        args = {
          path = path: head + path;
        };
      in
      packages.nixpkgs.lib.modules.evalModules {
        modules = [
          (makes.src)
          (args.path "/makes.nix")
        ];
        specialArgs = args;
      };

    # Makes' implementation source code
    src = ./src;
  };
  packages = {
    nixpkgs = import sources.nixpkgs { };
  };
  sources = import ./nix/sources.nix;
}
