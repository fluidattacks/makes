{ __nixpkgs__
, attrsMapToList
, fakeSha256
, makeDerivation
, toFileLst
, toFileToml
, ...
}:
{ dependencies ? { }
, name
, python
, sha256 ? fakeSha256
, subDependencies ? { }
}:
let
  toReqsTxt = dependencies:
    toFileLst "requirements.txt"
      (attrsMapToList (req: version: "${req}==${version}") dependencies);
in
makeDerivation {
  env = {
    envPyprojectToml = toFileToml "pyproject.toml" {
      build-system.build-backend = "poetry.core.masonry.api";
      build-system.requires = [ "poetry-core>=1.0.0" ];
      tool.poetry.authors = [ ];
      tool.poetry.dependencies = dependencies // subDependencies // {
        python = python.version;
      };
      tool.poetry.description = "";
      tool.poetry.name = name;
      tool.poetry.version = "1";
    };
    envCheckCompleteness = ./check-completeness.py;
    envDeps = toReqsTxt dependencies;
    envSubDeps = toReqsTxt subDependencies;
  };
  builder = ./builder.sh;
  name = "make-python-pypi-mirror-for-${name}";
  inherit sha256;
  searchPaths.bin = [
    __nixpkgs__.curl
    __nixpkgs__.poetry
    __nixpkgs__.pypi-mirror
    __nixpkgs__.yj
    __nixpkgs__.yq
    python
  ];
}
