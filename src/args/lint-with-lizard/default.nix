{ makeDerivation
, makeDerivationParallel
, makePythonPypiEnvironment
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
        (makePythonPypiEnvironment {
          dependencies.lizard = "1.17.3";
          name = "lizard";
          python = makePythonVersion "3.7";
          sha256 = "17pwl53zrfvi6m2f58mgn6vj6wfz6k23z6r01x21lmmf3w0hawg7";
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
