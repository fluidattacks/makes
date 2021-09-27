{ __nixpkgs__
, makeTemplate
, ...
}:
makeTemplate {
  searchPaths.bin = [ __nixpkgs__.git ];
  template = ./template.sh;
}
