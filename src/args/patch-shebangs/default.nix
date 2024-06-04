{ __nixpkgs__, makeTemplate, ... }:
makeTemplate {
  name = "patch-shebangs";
  searchPaths.bin = [ __nixpkgs__.findutils __nixpkgs__.gnused ];
  template = ./template.sh;
}
