(import ./src/evaluator/default.nix {
  makesSrc = ./.;
  projectSrc = ./.;
}).config.outputs."/"
