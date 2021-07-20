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
  name = "make-env-vars-for-terraform-for-${name}";
  template = ./template.sh;
}
