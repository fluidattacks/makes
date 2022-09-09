{
  inputs,
  makeDerivation,
  projectPath,
  ...
}:
makeDerivation {
  name = "docs";
  env.envDocs = projectPath "/docs";
  builder = ./builder.sh;
  searchPaths.bin = [inputs.nixpkgs.mdbook];
}
