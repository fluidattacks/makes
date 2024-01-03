{
  __nixpkgs__,
  makePythonVersion,
  makeScript,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "python-pypi2nix";
  replace = {
    __argPy39__ = makePythonVersion "3.9";
    __argPy310__ = makePythonVersion "3.10";
    __argPy311__ = makePythonVersion "3.11";
    __argPy312__ = makePythonVersion "3.12";
  };
  searchPaths.bin = [
    __nixpkgs__.curl
    __nixpkgs__.git
    __nixpkgs__.jq
    __nixpkgs__.nix
    __nixpkgs__.poetry
    __nixpkgs__.yj
  ];
}
