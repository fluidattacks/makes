{ __nixpkgs__, makeTemplate, ... }:
list:
makeTemplate {
  replace = { __argArray__ = __nixpkgs__.lib.strings.escapeShellArgs list; };
  name = "to-bash-array";
  template = ./template.sh;
}
