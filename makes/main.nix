{ makeDerivation
, ...
}:
makeDerivation {
  builder = "touch $out";
  name = "test";
}
