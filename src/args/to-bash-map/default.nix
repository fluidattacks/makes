{ __nixpkgs__, attrsMapToList, makeTemplate, ... }:
attrset:
let inherit (__nixpkgs__.lib.strings) escapeShellArg;
in makeTemplate {
  replace = {
    __argMap__ = builtins.toString (attrsMapToList
      (name: value: escapeShellArg "[${name}]=${escapeShellArg value}")
      attrset);
  };
  template = ./template.sh;
  name = "as-bash-map";
}
