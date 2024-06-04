{ __nixpkgs__, toBashArray, makeTemplate, toDerivationName, ... }:
{ vars, name, manifest, }:
makeTemplate {
  replace = {
    __argManifest__ = manifest;
    __argName__ = toDerivationName name;
    __argVars__ = toBashArray vars;
  };
  name = "make-secret-for-env-from-sops-for-${name}";
  searchPaths = { bin = [ __nixpkgs__.jq __nixpkgs__.sops ]; };
  template = ./template.sh;
}
