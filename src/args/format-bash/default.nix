{ __nixpkgs__, toBashArray, makeScript, ... }:
{ name, targets, ... }:
makeScript {
  replace = { __argTargets__ = toBashArray targets; };
  name = "format-bash-for-${name}";
  searchPaths = { bin = [ __nixpkgs__.shfmt ]; };
  entrypoint = ./entrypoint.sh;
}
