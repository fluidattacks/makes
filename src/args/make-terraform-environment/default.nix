{ __nixpkgs__, makeSearchPaths, ... }:
{ version }:
let
  terraform = {
    "0.14" = __nixpkgs__.terraform_0_14;
    "0.15" = __nixpkgs__.terraform_0_15;
    "1.0" = __nixpkgs__.terraform_1;
  }.${version};
in makeSearchPaths { bin = [ terraform ]; }
