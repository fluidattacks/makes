{ __nixpkgs__, toBashArray, makeScript, ... }:
{ name, targets, ... }:
makeScript {
  replace = { __argTargets__ = toBashArray targets; };
  name = "lint-nix-for-${name}";
  searchPaths = { bin = [ __nixpkgs__.statix ]; };
  entrypoint = ./entrypoint.sh;
}
