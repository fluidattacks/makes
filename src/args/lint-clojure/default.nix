{ makeDerivation
, makeDerivationParallel
, inputs
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
    name = "build-lint-clojure-for-${name}-${envTarget}";
    searchPaths = {
      bin = [
        inputs.nixpkgs.clj-kondo
      ];
    };
    builder = ./builder.sh;
  };
in
makeDerivationParallel {
  dependencies = builtins.map makeTarget targets;
  name = "lint-clojure-for-${name}";
}
