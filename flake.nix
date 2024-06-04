{
  description = "A DevSecOps framework powered by Nix!";

  inputs.nixpkgs.url = "github:nix-community/nixpkgs.lib";

  outputs = { nixpkgs, ... }@inputs:
    let
      makeOutputsForSystem = system: {
        apps.${system}.default = {
          program = "${inputs.self.packages.${system}.default}/bin/m";
          type = "app";
        };

        lib.${system} = import ./src/args/agnostic.nix { inherit system; };

        packages.${system}.default = import ./default.nix { inherit system; };
      };
    in builtins.foldl' nixpkgs.lib.recursiveUpdate { }
    (builtins.map makeOutputsForSystem [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ]);
}
