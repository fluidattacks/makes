{ toDerivationName
, ...
}:
projectSrc:
rel:
builtins.path {
  name = toDerivationName (builtins.baseNameOf rel);
  path = projectSrc + rel;
}
