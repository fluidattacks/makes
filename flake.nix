{
  description = "A DevSecOps framework powered by Nix!";

  inputs = {
    flakeUtils.url = "github:numtide/flake-utils";
  };

  outputs = { flakeUtils, ... }:
    (flakeUtils.lib.eachDefaultSystem
      (system:
        let makes = import ./default.nix { inherit system; };
        in
        {
          defaultPackage = makes;
          defaultApp.program = "${makes}/bin/m";
          defaultApp.type = "app";
        }))
    // {
      lib = {
        fromFlake = import ./src/evaluator/from-flake.nix;
      };
    };
}
