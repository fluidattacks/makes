{ makeEntrypoint
, makePythonPypiEnvironment
, toBashArray
, ...
}:
{ extraFlags
, name
, python
, src
, setup
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
makeEntrypoint {
  name = "test-python-for-${name}";
  replace = {
    __argExtraFlags__ = toBashArray extraFlags;
    __argSrc__ = src;
  };
  searchPaths = {
    source = [
      (pythonPypiEnvironment)
      (setup)
    ];
  };
}
