{ escapeShellArgs
, makeTemplate
, ...
}:
list:
makeTemplate {
  replace = {
    __argArray__ = escapeShellArgs list;
  };
  name = "to-bash-array";
  template = ./template.sh;
}
