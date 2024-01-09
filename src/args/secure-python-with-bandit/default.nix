{
  __nixpkgs__,
  makeDerivation,
  makePythonEnvironment,
  ...
}: {
  name,
  target,
}:
makeDerivation {
  builder = ./builder.sh;
  env.envTarget = target;
  name = "secure-python-with-bandit-for-${name}";
  searchPaths.source = [
    (makePythonEnvironment {
      pythonProjectDir = ./.;
      pythonVersion = "3.11";
    })
  ];
}
