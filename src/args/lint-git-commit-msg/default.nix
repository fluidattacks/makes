{ __nixpkgs__, makeScript, ... }:
{ branch, config, name, parser, src, }:
makeScript {
  name = "lint-git-commit-msg-for-${name}";
  replace = {
    __argBranch__ = branch;
    __argConfig__ = config;
    __argParser__ = parser;
    __argSrc__ = src;
  };
  searchPaths = { bin = [ __nixpkgs__.git __nixpkgs__.nodejs_21 ]; };
  entrypoint = ./entrypoint.sh;
}
