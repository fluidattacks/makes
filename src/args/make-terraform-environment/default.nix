{ __nixpkgs__
, makeSearchPaths
, ...
}:
{ version
}:
let
  terraform = {
    "0.12" = __nixpkgs__.terraform_0_12;
    "0.13" = __nixpkgs__.terraform_0_13;
    "0.14" = __nixpkgs__.terraform_0_14;
    "0.15" = __nixpkgs__.terraform_0_15;
    "0.16" = __nixpkgs__.terraform_0_16;
  }.${version};
in
makeSearchPaths {
  bin = [ terraform ];
}
