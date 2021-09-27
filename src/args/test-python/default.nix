{ makePythonPypiEnvironment
, makeSearchPaths
, makeScript
, toBashArray
, toBashMap
, ...
}:
{ extraFlags
, extraSrcs
, name
, project
, python
, searchPaths
, src
}:
let
  pythonPypiEnvironment = makePythonPypiEnvironment {
    inherit name;
    sourcesYaml = {
      "3.6" = ./pypi-sources-3.6.yaml;
      "3.7" = ./pypi-sources-3.7.yaml;
      "3.8" = ./pypi-sources-3.8.yaml;
      "3.9" = ./pypi-sources-3.9.yaml;
    }.${python};
  };
in
makeScript {
  name = "test-python-for-${name}";
  replace = {
    __argExtraFlags__ = toBashArray extraFlags;
    __argExtraSrcs__ = toBashMap extraSrcs;
    __argProject__ = project;
    __argSrc__ = src;
  };
  entrypoint = ./entrypoint.sh;
  searchPaths = {
    source = [ pythonPypiEnvironment (makeSearchPaths searchPaths) ];
  };
}
