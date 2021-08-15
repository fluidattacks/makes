{ __nixpkgs__
, attrsMapToList
, fakeSha256
, makeDerivation
, makePythonEnvironment
, makePythonVersion
, toFileLst
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

  pythonPypiMirror = makePythonEnvironment {
    name = "python-pypi-mirror";
    dependencies = [
      "python-pypi-mirror==4.0.6"
    ];
    python = makePythonVersion "3.8";
  };
in
makeDerivation {
  env = {
    envCheckCompleteness = ./check-completeness.py;
    envDeps = toReqsTxt dependencies;
    envSubDeps = toReqsTxt subDependencies;
  };
  builder = ./builder.sh;
  name = "make-python-pypi-mirror-for-${name}";
  inherit sha256;
  searchPaths = {
    bin = [ __nixpkgs__.findutils python ];
    source = [ pythonPypiMirror ];
  };
}
