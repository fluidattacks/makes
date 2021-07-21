{ makeDerivation
, makeDerivationParallel
, makePythonEnvironment
, ...
}:
{ targets
, name
, ...
}:
let
  makeTarget = src: makeDerivation {
    env = {
      envTarget = src;
    };
    name = "build-lint-with-lizard-for-${name}-${src}";
    searchPaths = {
      source = [
        (makePythonEnvironment {
          dependencies = [
            "lizard==1.17.3"
          ];
          name = "lizard";
          python = "3.7";
        })
      ];
    };
    builder = ./builder.sh;
  };
in
makeDerivationParallel {
  dependencies = builtins.map makeTarget targets;
  name = "lint-with-lizard-for-${name}";
}
