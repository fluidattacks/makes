{
  inputs,
  makePythonPypiEnvironment,
  makeSearchPaths,
  ...
}:
makeSearchPaths {
  bin = [inputs.nixpkgs.mkdocs];
  source = [
    (makePythonPypiEnvironment {
      name = "docs-runtime-pypi";
      sourcesYaml = ./pypi/sources.yaml;
    })
  ];
}
