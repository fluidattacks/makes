{ __nixpkgs__
, asBashMap
, makeTemplate
, toDerivationName
, ...
}:
{ mapping
, name
}:
makeTemplate {
  replace = {
    __argName__ = toDerivationName name;
    __argMap__ = asBashMap mapping;
  };
  name = "make-secret-for-terraform-from-env-for-${name}";
  template = ./template.sh;
}
