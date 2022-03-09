{
  __nixpkgs__,
  toBashArray,
  makeDerivation,
  ...
}: {
  name,
  config,
  targets,
}:
makeDerivation {
  env = {
    envConfig = config;
    envTargets = toBashArray targets;
  };
  name = "lint-markdown-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.mdl
    ];
  };
  builder = ./builder.sh;
}
