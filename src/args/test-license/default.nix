{ __nixpkgs__, makeScript, ... }:
makeScript {
  name = "test-license";
  entrypoint = ./entrypoint.sh;
  searchPaths.bin = [ __nixpkgs__.git __nixpkgs__.reuse ];
}
