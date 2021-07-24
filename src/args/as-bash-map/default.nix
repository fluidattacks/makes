{ mapAttrsToList
, makeTemplate
, escapeShellArg
, ...
}:
attrset:
makeTemplate {
  replace = {
    __argMap__ = builtins.toString
      (mapAttrsToList
        (name: value: escapeShellArg "[${name}]=${value}")
        attrset);
  };
  template = ./template.sh;
  name = "bash-map";
}
