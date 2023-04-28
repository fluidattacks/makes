{
  makeDerivation,
  makePythonPypiEnvironment,
  makeSearchPaths,
  ...
}: {
  config,
  name,
  searchPaths,
  src,
}:
makeDerivation {
  builder = ./builder.sh;
  env = {
    envConfig = config;
    envSrc = src;
  };
  name = "lint-python-imports-for-${name}";
  searchPaths.source = [
    (makeSearchPaths searchPaths)
    (makePythonPypiEnvironment {
      name = "lint-python-imports";
      sourcesYaml = ./pypi-sources.yaml;
      withSetuptools_67_7_2 = true;
      withSetuptoolsScm_7_1_0 = true;
      withWheel_0_40_0 = true;
    })
  ];
}
