{ __nixpkgs__
, makeDerivation
, ...
}:
envSrc:
makeDerivation {
  env = {
    inherit envSrc;
  };
  name = "to-file-json-from-file-yaml";
  searchPaths = {
    bin = [
      __nixpkgs__.yq
    ];
  };
  builder = ./builder.sh;
}
