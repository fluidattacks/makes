{ __nixpkgs__
, makeSearchPaths
, ...
}:
{ version }:
let
  terraform = {
    "0.14" = __nixpkgs__.terraform_0_14;
    "0.15" = __nixpkgs__.terraform_0_15;
    "0.16" = __nixpkgs__.terraform_0_16;
  }.${version};
in
makeSearchPaths {
  bin = [ terraform ];
}
