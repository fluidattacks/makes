{makePythonPypiEnvironment, ...}:
makePythonPypiEnvironment {
  name = "cli-env-test";
  sourcesYaml = ./pypi-sources.yaml;
}
