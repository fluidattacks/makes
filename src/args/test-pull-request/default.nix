{
  escapeShellArgs,
  makeNodeJsEnvironment,
  makeScript,
  ...
}: {
  dangerfile,
  extraArgs,
  name,
  setup,
  ...
}: let
  env = makeNodeJsEnvironment {
    name = "danger";
    nodeJsVersion = "21";
    packageJson = ./package.json;
    packageLockJson = ./package-lock.json;
  };
in
  makeScript {
    entrypoint = ./entrypoint.sh;
    replace = {
      __argDangerfile__ = dangerfile;
      __argExtraArgs__ = escapeShellArgs extraArgs;
    };
    name = "test-pull-request-for-${name}";
    searchPaths.source = [env] ++ setup;
  }
