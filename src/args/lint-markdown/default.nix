{
  __nixpkgs__,
  toBashArray,
  makeDerivation,
  ...
}: {
  name,
  config,
  targets,
  rulesets,
}:
makeDerivation {
  env = {
    envConfig = config;
    envTargets = toBashArray targets;
    envRulesets = rulesets;
  };
  name = "lint-markdown-for-${name}";
  searchPaths = {
    bin = [
      __nixpkgs__.mdl
    ];
  };
  builder = ./builder.sh;
}
