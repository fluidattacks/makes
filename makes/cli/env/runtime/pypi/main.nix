{makePythonPypiEnvironment, ...}:
makePythonPypiEnvironment {
  name = "cli-env-runtime-pypi";
  sourcesYaml = ./pypi-sources.yaml;
}
