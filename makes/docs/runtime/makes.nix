{ __nixpkgs__, makePythonEnvironment, makeSearchPaths, outputs, ... }: {
  jobs."/docs/runtime" = makeSearchPaths {
    bin = [ __nixpkgs__.git __nixpkgs__.mkdocs ];
    source = [ outputs."/docs/runtime/pypi" ];
  };
}
