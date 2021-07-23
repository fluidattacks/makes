{ __nixpkgs__
, projectPath
, ...
}:
{ regex
, targets
}:
let
  projectPathsMatchingInTarget =
    target:
    let
      targetInNixStore = projectPath target;
      matchingPaths = builtins.filter
        (path: builtins.match regex path != null)
        (__nixpkgs__.lib.filesystem.listFilesRecursive targetInNixStore);
      matchingPathsRelative = builtins.map
        (path: target + (__nixpkgs__.lib.removePrefix targetInNixStore path))
        (matchingPaths);
    in
    builtins.map builtins.unsafeDiscardStringContext matchingPathsRelative;
in
builtins.concatLists
  (builtins.map projectPathsMatchingInTarget targets)
