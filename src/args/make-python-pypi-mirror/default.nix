{ __nixpkgs__
, attrsMapToList
, fakeSha256
, fetchUrl
, listOptional
, makeDerivation
, toBashArray
, toFileLst
, toFileToml
, ...
}:
{ dependencies ? { }
, name
, python
, sha256 ? fakeSha256
, subDependencies ? { }
, withSetupTools57 ? true
, withWheel37 ? true
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
      tool.poetry.name = "pyproject-toml-for-make-python-pypi-mirror";
      tool.poetry.version = "1";
    };
    envCheckCompleteness = ./check-completeness.py;
    envDeps = toReqsTxt dependencies;
    envSubDeps = toReqsTxt subDependencies;
    envExtraFiles = toBashArray (builtins.concatLists [
      (listOptional withSetupTools57 (fetchUrl {
        url = "https://pypi.org/packages/py3/s/setuptools/setuptools-57.4.0-py3-none-any.whl";
        sha256 = "1mhq6jw21sglccqmimydqi2rjvh3g5xjykb16gcvkkx6gabk14m4";
      }))
      (listOptional withWheel37 (fetchUrl {
        url = "https://pypi.org/packages/py2.py3/w/wheel/wheel-0.37.0-py2.py3-none-any.whl";
        sha256 = "1za6c4s0yjy1dzprmib3kph40hr8xgj3apdsnqs00v9wv4mln091";
      }))
    ]);
  };
  builder = ./builder.sh;
  name = "make-python-pypi-mirror-for-${name}";
  inherit sha256;
  searchPaths.bin = [
    __nixpkgs__.curl
    __nixpkgs__.jq
    __nixpkgs__.poetry
    __nixpkgs__.pypi-mirror
    __nixpkgs__.yj
    python
  ];
}
