{ __nixpkgs__
, asBashMap
, makeTemplate
, ...
}:
{ mapping
, name
}:
makeTemplate {
  replace = {
    __argMap__ = asBashMap mapping;
  };
  name = "make-secret-for-terraform-from-env-for-${name}";
  template = ./template.sh;
}
