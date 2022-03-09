{
  __nixpkgs__,
  makeNodeJsEnvironment,
  makeScript,
  ...
}: {
  branch,
  config,
  name,
  parser,
  src,
}: let
  commitlint = makeNodeJsEnvironment {
    name = "commitlint";
    nodeJsVersion = "12";
    packageJson = ./commitlint/package.json;
    packageLockJson = ./commitlint/package-lock.json;
  };
in
  makeScript {
    name = "lint-git-commit-msg-for-${name}";
    replace = {
      __argBranch__ = branch;
      __argConfig__ = config;
      __argParser__ = parser;
      __argSrc__ = src;
    };
    searchPaths = {
      bin = [__nixpkgs__.git];
      source = [commitlint];
    };
    entrypoint = ./entrypoint.sh;
  }
