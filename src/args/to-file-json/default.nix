{ makeDerivation
, ...
}:
name: expr: makeDerivation {
  env.envAll = builtins.toJSON expr;
  builder = ''echo "$envAll" > $out'';
  inherit name;
}
