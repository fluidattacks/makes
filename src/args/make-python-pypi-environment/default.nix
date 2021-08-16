{ fakeSha256
, getAttr
, listOptional
, makeDerivation
, makePythonPypiMirror
, makePythonVersion
, makeSearchPaths
, ...
}:
{ dependencies ? { }
, name
, python
, sha256 ? fakeSha256
, searchPaths ? { }
, subDependencies ? { }
}:
let
  pypiEnvironment = makeDerivation {
    builder = ./builder.sh;
    env.envMirror = makePythonPypiMirror {
      inherit dependencies;
      inherit name;
      inherit python;
      inherit sha256;
      inherit subDependencies;
    };
    inherit name;
    searchPaths = searchPaths // {
      bin = (getAttr searchPaths "bin" [ ]) ++ [ python ];
    };
  };
in
makeSearchPaths {
  bin = [ pypiEnvironment ];
  pythonPackage37 = listOptional (python == makePythonVersion "3.7") pypiEnvironment;
  pythonPackage38 = listOptional (python == makePythonVersion "3.8") pypiEnvironment;
  pythonPackage39 = listOptional (python == makePythonVersion "3.9") pypiEnvironment;
}
