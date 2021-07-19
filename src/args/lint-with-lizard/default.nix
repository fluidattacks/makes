{ asBashArray
, makeDerivation
, makePythonEnvironment
, ...
}:
{ name
, targets
}:
makeDerivation {
  env = {
    envTargets = asBashArray targets;
  };
  name = "lint-with-lizard-for-${name}";
  searchPaths = {
    source = [
      (makePythonEnvironment {
        dependencies = [
          "lizard==1.17.9"
        ];
        name = "lizard";
        python = "3.8";
      })
    ];
  };
  builder = ./builder.sh;
}
