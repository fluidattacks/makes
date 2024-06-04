{ makeDerivation, makeDerivationParallel, makePythonEnvironment, ... }:
{ targets, name, ... }:
let
  makeTarget = envTarget:
    makeDerivation {
      env = { inherit envTarget; };
      name = "build-lint-with-lizard-for-${name}-${envTarget}";
      searchPaths = {
        source = [
          (makePythonEnvironment {
            pythonProjectDir = ./.;
            pythonVersion = "3.11";
          })
        ];
      };
      builder = ./builder.sh;
    };
in makeDerivationParallel {
  dependencies = builtins.map makeTarget targets;
  name = "lint-with-lizard-for-${name}";
}
