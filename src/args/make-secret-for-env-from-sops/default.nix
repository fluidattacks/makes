{ __nixpkgs__
, asBashArray
, makeTemplate
, toDerivationName
, ...
}:
{ vars
, name
, target
}:
makeTemplate {
  replace = {
    __argName__ = toDerivationName name;
    __argTarget__ = target;
    __argVars__ = asBashArray vars;
  };
  name = "make-secret-for-env-from-sops-for-${name}";
  searchPaths = {
    bin = [ __nixpkgs__.jq __nixpkgs__.sops ];
  };
  template = ./template.sh;
}
