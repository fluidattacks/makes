{ __nixpkgs__, makeScript, ... }: {
  jobs."/utils/makePythonLock" = makeScript {
    entrypoint = ./entrypoint.sh;
    name = "make-python-lock";
    searchPaths.bin = [
      __nixpkgs__.poetry
      __nixpkgs__.python39
      __nixpkgs__.python310
      __nixpkgs__.python311
      __nixpkgs__.python312
    ];
  };
}
