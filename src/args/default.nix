{ inputs
, makesExecutionId
, outputs
, projectSrc
, projectSrcMutable
, system
, ...
}:
let
  agnostic = import ./agnostic.nix { inherit system; };

  args = agnostic // {
    inherit inputs;
    inherit makesExecutionId;
    inherit outputs;
    inherit projectSrc;
    projectPath = import ./project-path/default.nix args;
    projectPathLsDirs = import ./project-path-ls-dirs/default.nix args;
    projectPathMutable = rel: projectSrcMutable + rel;
    projectPathsMatching = import ./project-paths-matching/default.nix args;
    projectSrcInStore = builtins.path { name = "head"; path = projectSrc; };
    inherit projectSrcMutable;
  };
in
args
