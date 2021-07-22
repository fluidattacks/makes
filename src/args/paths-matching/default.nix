{ path
, __nixpkgs__
, ...
}:
{ regex
, targets
}:
let
  root = path "";
  allFiles = __nixpkgs__.lib.flatten (builtins.map
    (target:
      __nixpkgs__.lib.filesystem.listFilesRecursive (path target))
    targets);
  matchesRegex = string: builtins.match regex string != null;
  matchedFiles = builtins.map
    (__nixpkgs__.lib.removePrefix root)
    (builtins.filter matchesRegex allFiles);
in
builtins.map builtins.unsafeDiscardStringContext matchedFiles
