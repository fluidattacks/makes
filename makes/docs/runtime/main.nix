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
    })
  ];
}
