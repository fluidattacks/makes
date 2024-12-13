{ __nixpkgs__, projectPath, ... }:
rel:
let
  isDir = _: value: value == "directory";
  ls = builtins.readDir (projectPath rel);
  dirs = __nixpkgs__.lib.filterAttrs isDir ls;
  dirNames = builtins.attrNames dirs;
in builtins.map builtins.unsafeDiscardStringContext dirNames
