{ makeDerivation
, makeDerivationParallel
, makePythonPypiEnvironment
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
        (makePythonPypiEnvironment {
          name = "lizard";
          sourcesJson = ./sources.json;
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
