{ attrsMapToList, makeTemplate, escapeShellArg, ... }:
attrset:
makeTemplate {
  replace = {
    __argMap__ = builtins.toString (attrsMapToList
      (name: value: escapeShellArg "[${name}]=${escapeShellArg value}")
      attrset);
  };
  template = ./template.sh;
  name = "as-bash-map";
}
