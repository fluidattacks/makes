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
  name = "make-env-vars-for-terraform-for-${name}";
  template = ./template.sh;
}
