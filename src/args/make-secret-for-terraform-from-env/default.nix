{ __nixpkgs__, toBashMap, makeTemplate, toDerivationName, ... }:
{ mapping, name, }:
makeTemplate {
  replace = {
    __argName__ = toDerivationName name;
    __argMap__ = toBashMap mapping;
  };
  name = "make-secret-for-terraform-from-env-for-${name}";
  template = ./template.sh;
}
