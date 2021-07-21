{ path
, __nixpkgs__
, ...
}:
{ regex
, target
}:
let
  root = path "";
  allFiles = __nixpkgs__.lib.filesystem.listFilesRecursive (path target);
  matchesRegex = string: builtins.match regex string != null;
  matchedFiles = builtins.map
    (__nixpkgs__.lib.removePrefix root)
    (builtins.filter matchesRegex allFiles);
in
builtins.map builtins.unsafeDiscardStringContext matchedFiles
