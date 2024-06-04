{ __nixpkgs__, listFilesRecursive, projectPath, removePrefix, ... }:
{ regex, targets, }:
let
  projectPathsMatchingInTarget = target:
    let
      targetInNixStore = projectPath target;
      matchingPaths = builtins.filter (path: builtins.match regex path != null)
        (listFilesRecursive targetInNixStore);
      matchingPathsRelative =
        builtins.map (path: target + (removePrefix targetInNixStore path))
        matchingPaths;
    in builtins.map builtins.unsafeDiscardStringContext matchingPathsRelative;
in builtins.concatLists (builtins.map projectPathsMatchingInTarget targets)
