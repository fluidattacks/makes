{
  inputs,
  makeSearchPaths,
  ...
}:
makeSearchPaths {
  bin = [
    inputs.nixpkgs.git
  ];
}
