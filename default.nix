{ system ? builtins.currentSystem }:
let
  agnostic = import ./src/args/agnostic.nix { inherit system; };

  args = agnostic // {
    outputs."/src/cli/runtime" =
      (import ./src/cli/makes.nix args).jobs."/src/cli/runtime";
    projectPath = import ./src/args/project-path args;
    projectSrc = ./.;
  };
in (import ./src/makes.nix args).jobs."/"
