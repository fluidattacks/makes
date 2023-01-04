{
  inputs,
  makeScript,
  ...
}:
makeScript {
  name = "docs-dev";
  entrypoint = ./entrypoint.sh;
  searchPaths.bin = [
    inputs.nixpkgs.mdbook
    inputs.nixpkgs.mdbook-mermaid
  ];
}
