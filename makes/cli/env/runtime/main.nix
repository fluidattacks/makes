{
  __nixpkgs__,
  makeSearchPaths,
  outputs,
  ...
}:
makeSearchPaths {
  bin = [
    __nixpkgs__.cachix
    __nixpkgs__.git
    __nixpkgs__.gnutar
    __nixpkgs__.gzip
    __nixpkgs__.nixStable
    __nixpkgs__.openssh
  ];
  source = [
    outputs."/cli/env/runtime/pypi"
  ];
}
