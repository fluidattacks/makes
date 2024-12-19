{ makePythonEnvironment, ... }: {
  jobs."/cli/env/runtime/pypi" = makePythonEnvironment {
    pythonProjectDir = ./.;
    pythonVersion = "3.11";
  };
}
