{ __nixpkgs__, toBashArray, makeScript, ... }:
{ name, targets, ... }:
makeScript {
  replace = { __argTargets__ = toBashArray targets; };
  name = "format-terraform-for-${name}";
  searchPaths = { bin = [ __nixpkgs__.terraform ]; };
  entrypoint = ./entrypoint.sh;
}
