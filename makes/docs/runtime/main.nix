{
  makePythonPypiEnvironment,
  makeSearchPaths,
  __nixpkgs__,
  ...
}:
makeSearchPaths {
  bin = [
    __nixpkgs__.git
    __nixpkgs__.mkdocs
  ];
  source = [
    (makePythonPypiEnvironment {
      name = "docs-runtime-pypi";
      sourcesYaml = ./pypi/sources.yaml;
      withSetuptools_67_7_2 = true;
      withSetuptoolsScm_7_1_0 = true;
      withWheel_0_40_0 = true;
    })
  ];
}
