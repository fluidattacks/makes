{
  inputs,
  makeScript,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "license";
  searchPaths.bin = [
    inputs.nixpkgs.git
    inputs.nixpkgs.reuse
  ];
}
