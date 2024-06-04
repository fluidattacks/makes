{ __nixpkgs__, makeDerivation, toFileJson, ... }:
name: expr:
makeDerivation {
  builder = ''
    yq -y < $envData > $out
  '';
  inherit name;
  env.envData = toFileJson name expr;
  local = true;
  searchPaths.bin = [ __nixpkgs__.yq ];
}
