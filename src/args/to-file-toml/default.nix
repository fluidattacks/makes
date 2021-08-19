{ __nixpkgs__
, makeDerivation
, ...
}:
name: expr: makeDerivation {
  envFiles.envAll = builtins.toJSON expr;
  builder = "yj -jt < $envAllPath > $out";
  inherit name;
  searchPaths.bin = [ __nixpkgs__.yj ];
}
