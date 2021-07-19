{ __nixpkgs__
, ...
}:
makeOutput:
expr:
(builtins.foldl'
  (all: one: all // { "${one.name}" = one.value; })
  { }
  (__nixpkgs__.lib.lists.flatten
    (if builtins.typeOf expr == "list"
    then
      (builtins.map makeOutput expr)
    else if builtins.typeOf expr == "set"
    then
      (__nixpkgs__.lib.attrsets.mapAttrsToList makeOutput expr)
    else
      abort "Not implement"
    )))
