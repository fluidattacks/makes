{ makeDerivation
, ...
}:
{ dependencies
, name
}:
makeDerivation {
  env = {
    envDependencies = dependencies;
  };
  builder = "echo $envDependencies > $out";
  name = "make-derivation-parallel-for-${name}";
}
