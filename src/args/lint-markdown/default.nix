{ __nixpkgs__
, asBashArray
, makeDerivation
, ...
}:
{ name
, config
, targets
}:
makeDerivation {
  env = {
    envConfig = config;
    envTargets = asBashArray targets;
  };
  name = "lint-markdown-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.mdl
    ];
  };
  builder = ./builder.sh;
}
