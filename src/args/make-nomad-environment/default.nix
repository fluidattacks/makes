{ __nixpkgs__
, makeSearchPaths
, ...
}:
{ version }:
let
  nomad = {
    "1.0" = __nixpkgs__.nomad_1_0;
    "1.1" = __nixpkgs__.nomad_1_1;
  }.${version};
in
makeSearchPaths {
  bin = [ nomad ];
}

