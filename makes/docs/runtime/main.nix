{
  __nixpkgs__,
  makePythonEnvironment,
  makeSearchPaths,
  outputs,
  ...
}:
makeSearchPaths {
  bin = [
    __nixpkgs__.git
    __nixpkgs__.mkdocs
  ];
  source = [outputs."/docs/runtime/pypi"];
}
