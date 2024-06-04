{ __nixpkgs__, makeScript, toBashArray, ... }:
{ name, targets, ... }:
makeScript {
  name = "format-yaml-for-${name}";
  replace = { __argTargets__ = toBashArray targets; };
  searchPaths = {
    bin = [ __nixpkgs__.findutils __nixpkgs__.nodePackages.prettier ];
  };
  entrypoint = ./entrypoint.sh;
}
