{
  description = "";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {self, flake-utils}:
    flake-utils.lib.eachDefaultSystem (system: {
       defaultPackage = import ./. { inherit system; };
    });
}
