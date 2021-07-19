{ makeDerivation
, makePythonEnvironment
, ...
}:
{ target
, name
}:
makeDerivation {
  env = {
    envTarget = target;
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
