{ __nixpkgs__
, ...
}:
makeOutput:
attrset:
(builtins.foldl'
  (all: one: all // { "${one.name}" = one.value; })
  { }
  (__nixpkgs__.lib.lists.flatten
    (__nixpkgs__.lib.attrsets.mapAttrsToList
      makeOutput
      attrset)))
