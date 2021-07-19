{ path
, __nixpkgs__
, ...
}:
{ regex
, target
}:
let
  allFiles = __nixpkgs__.lib.filesystem.listFilesRecursive (path target);
  matchesRegex = string: builtins.match regex string != null;
  matchedFiles = builtins.filter matchesRegex allFiles;
in
builtins.map (__nixpkgs__.lib.removePrefix (path "/")) matchedFiles
