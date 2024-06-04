{ __nixpkgs__, ... }:
list: start: end:
let
  inherit (__nixpkgs__) lib;

  range = lib.lists.range start (end - 1);
in builtins.map (lib.lists.elemAt list) range
