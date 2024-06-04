{ __nixpkgs__, flatten, attrsMapToList, ... }:
makeOutput: set:
(builtins.foldl' (all: one:
  all // (if one == { } then { } else { "${one.name}" = one.value; })) { }
  (flatten (attrsMapToList makeOutput set)))
