{ __nixpkgs__, filterAttrs, projectPath, ... }:
rel:
let
  isDir = _: value: value == "directory";
  ls = builtins.readDir (projectPath rel);
  dirs = filterAttrs isDir ls;
  dirNames = builtins.attrNames dirs;
in builtins.map builtins.unsafeDiscardStringContext dirNames
