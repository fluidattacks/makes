{ toBashArray, makeScript, __nixpkgs__, ... }:
{ name, targets, ... }:
makeScript {
  replace = { __argTargets__ = toBashArray targets; };
  name = "format-nix-for-${name}";
  searchPaths = { bin = [ __nixpkgs__.nixfmt ]; };
  entrypoint = ./entrypoint.sh;
}
