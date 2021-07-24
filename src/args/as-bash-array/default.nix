{ escapeShellArgs
, makeTemplate
, ...
}:
list:
makeTemplate {
  replace = {
    __argArray__ = escapeShellArgs list;
  };
  name = "as-bash-array";
  template = ./template.sh;
}
