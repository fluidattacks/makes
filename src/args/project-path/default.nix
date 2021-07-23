{ projectSrc
, ...
}:
rel:
builtins.path {
  name = "projectPath";
  path = projectSrc + rel;
}
