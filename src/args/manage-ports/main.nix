{ __nixpkgs__
, makeTemplate
, ...
}:
makeTemplate {
  name = "manage-ports";
  searchPaths = {
    bin = [
      __nixpkgs__.lsof
    ];
  };
  template = ./template.sh;
}
