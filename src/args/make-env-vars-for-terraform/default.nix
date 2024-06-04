{ __nixpkgs__, toBashMap, makeTemplate, toDerivationName, ... }:
{ mapping, name, }:
makeTemplate {
  replace = {
    __argName__ = toDerivationName name;
    __argMap__ = toBashMap mapping;
  };
  name = "make-env-vars-for-terraform-for-${name}";
  template = ./template.sh;
}
