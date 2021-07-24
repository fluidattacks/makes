{ __nixpkgs__
, flatten
, mapAttrsToList
, ...
}:
makeOutput:
set:
(builtins.foldl'
  (all: one: all // { "${one.name}" = one.value; })
  { }
  (flatten (mapAttrsToList makeOutput set)))
