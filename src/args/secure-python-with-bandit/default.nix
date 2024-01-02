{
  __nixpkgs__,
  makeDerivation,
  makePythonPypiEnvironment,
  ...
}: {
  name,
  python,
  target,
}: let
  pythonPypiEnvironment = makePythonPypiEnvironment {
    inherit name;
    sourcesYaml =
      {
        "3.9" = ./pypi-sources-3.9.yaml;
        "3.10" = ./pypi-sources-3.10.yaml;
        "3.11" = ./pypi-sources-3.11.yaml;
        "3.12" = ./pypi-sources-3.12.yaml;
      }
      .${python};
  };
in
  makeDerivation {
    builder = ./builder.sh;
    env = {
      envTarget = target;
    };
    name = "secure-python-with-bandit-for-${name}";
    searchPaths = {
      source = [pythonPypiEnvironment];
    };
  }
