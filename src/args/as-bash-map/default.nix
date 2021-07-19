{ __nixpkgs__
, makeTemplate
, ...
}:
attrset:
makeTemplate {
  replace = {
    __argMap__ = builtins.toString
      (__nixpkgs__.lib.mapAttrsToList
        (name: value: __nixpkgs__.lib.strings.escapeShellArg "[${name}]=${value}")
        attrset);
  };
  template = ./template.sh;
  name = "bash-map";
}
