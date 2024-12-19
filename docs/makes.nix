{ __nixpkgs__, makeScript, ... }: {
  jobs."/docs" = makeScript {
    name = "docs";
    entrypoint = ./entrypoint.sh;
    searchPaths.bin = [ __nixpkgs__.git __nixpkgs__.poetry ];
  };
}
