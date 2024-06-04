{ __nixpkgs__, makeTemplate, ... }:
makeTemplate {
  name = "lib-git";
  searchPaths.bin = [ __nixpkgs__.git ];
  template = ./template.sh;
}
