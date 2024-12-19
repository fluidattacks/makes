{ system ? builtins.currentSystem }:
let
  agnostic = import ./src/args/agnostic.nix { inherit system; };

  args = agnostic // {
    outputs."/cli/env/runtime" =
      (import ./makes/cli/env/runtime/makes.nix args).jobs."/cli/env/runtime";
    outputs."/cli/env/runtime/pypi" =
      (import ./makes/cli/env/runtime/pypi/makes.nix
        args).jobs."/cli/env/runtime/pypi";
    projectPath = import ./src/args/project-path args;
    projectSrc = ./.;
  };
in (import ./makes/makes.nix args).jobs."/"
