{
  makePythonEnvironment,
  makeSearchPaths,
  makeScript,
  toBashArray,
  toBashMap,
  ...
}: {
  extraFlags,
  extraSrcs,
  name,
  project,
  searchPaths,
  src,
}:
makeScript {
  name = "test-python-for-${name}";
  replace = {
    __argExtraFlags__ = toBashArray extraFlags;
    __argExtraSrcs__ = toBashMap extraSrcs;
    __argProject__ = project;
    __argSrc__ = src;
  };
  entrypoint = ./entrypoint.sh;
  searchPaths = {
    source = [
      (makePythonEnvironment {
        pythonProjectDir = ./.;
        pythonVersion = "3.11";
      })
      (makeSearchPaths searchPaths)
    ];
  };
}
