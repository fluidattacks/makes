{ makeDerivation
, ...
}:
name: expr: makeDerivation {
  envFiles.envAll = builtins.toJSON expr;
  builder = "cp $envAllPath $out";
  inherit name;
}
