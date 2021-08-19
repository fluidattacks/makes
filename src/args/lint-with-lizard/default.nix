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
          sha256 = "0kibmxrl13i9j2cidmlkrkcq341276cl5w76jgajwfcx09gbn58y";
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
