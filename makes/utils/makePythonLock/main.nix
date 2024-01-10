{
  __nixpkgs__,
  makeScript,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-python-lock";
  searchPaths.bin = [__nixpkgs__.poetry];
}
