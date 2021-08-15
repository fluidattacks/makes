{ makeDerivation
, makeDerivationParallel
, makePythonEnvironment
, makePythonVersion
, ...
}:
{ targets
, name
, ...
}:
let
  makeTarget = envTarget: makeDerivation {
    env = {
      inherit envTarget;
    };
    name = "build-lint-with-lizard-for-${name}-${envTarget}";
    searchPaths = {
      source = [
        (makePythonEnvironment {
          dependencies = [
            "lizard==1.17.3"
          ];
          name = "lizard";
          python = makePythonVersion "3.7";
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
