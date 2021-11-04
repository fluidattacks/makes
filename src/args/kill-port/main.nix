{ __nixpkgs__
, makeTemplate
, ...
}:
makeTemplate {
  name = "kill-port";
  searchPaths = {
    bin = [
      __nixpkgs__.lsof
    ];
  };
  template = ./template.sh;
}
