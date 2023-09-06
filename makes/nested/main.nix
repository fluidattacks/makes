{
  makeSearchPaths,
  __nixpkgs__,
  ...
}:
makeSearchPaths {
  bin = [
    __nixpkgs__.git
  ];
}
