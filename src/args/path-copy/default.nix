{ toDerivationName
, ...
}:
head:
rel:
builtins.path {
  name = toDerivationName (builtins.baseNameOf rel);
  path = head + rel;
}
