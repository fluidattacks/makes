{
  inputs,
  makeScript,
  ...
}:
makeScript {
  name = "docs";
  entrypoint = ./entrypoint.sh;
  searchPaths.bin = [
    inputs.nixpkgs.mdbook
    inputs.nixpkgs.mdbook-mermaid
  ];
}
