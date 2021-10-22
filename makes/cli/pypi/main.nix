{ makePythonPypiEnvironment
, ...
}:
makePythonPypiEnvironment {
  name = "cli-pypi";
  sourcesYaml = ./pypi-sources.yaml;
}
