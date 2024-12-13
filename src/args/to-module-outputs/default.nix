{ __nixpkgs__, attrsMapToList, ... }:
makeOutput: set:
(builtins.foldl' (all: one:
  all // (if one == { } then { } else { "${one.name}" = one.value; })) { }
  (__nixpkgs__.lib.lists.flatten (attrsMapToList makeOutput set)))
