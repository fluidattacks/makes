{
  __nixpkgs__,
  makePythonPypiEnvironment,
  makeScript,
  toBashArray,
  ...
}: {
  name,
  targets,
  ...
}:
makeScript {
  name = "format-yaml-for-${name}";
  replace = {
    __argTargets__ = toBashArray targets;
  };
  searchPaths = {
    bin = [
      __nixpkgs__.findutils
      __nixpkgs__.git
    ];
    source = [
      (makePythonPypiEnvironment {
        name = "yamlfix";
        sourcesYaml = ./sources.yaml;
      })
    ];
  };
  entrypoint = ./entrypoint.sh;
}
