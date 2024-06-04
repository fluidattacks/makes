{ __nixpkgs__, makeDerivation, ... }:
envSrc:
makeDerivation {
  env = { inherit envSrc; };
  local = true;
  name = "to-file-json-from-file-yaml";
  searchPaths = { bin = [ __nixpkgs__.yq ]; };
  builder = ./builder.sh;
}
