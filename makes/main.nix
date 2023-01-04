{
  __nixpkgs__,
  makeScript,
  outputs,
  projectPath,
  ...
}: let
  makesVersion = "22.11";
in
  makeScript {
    aliases = [
      "m-v${makesVersion}"
      "makes"
      "makes-v${makesVersion}"
    ];
    replace = {
      __argMakesSrc__ = projectPath "/";
      __argNixStable__ = __nixpkgs__.nixStable;
      __argNixUnstable__ = __nixpkgs__.nixUnstable;
    };
    entrypoint = ''
      __MAKES_SRC__=__argMakesSrc__ \
      __NIX_STABLE__=__argNixStable__ \
      __NIX_UNSTABLE__=__argNixUnstable__ \
      python -u __argMakesSrc__/src/cli/main/__main__.py "$@"
    '';
    searchPaths.source = [
      outputs."/cli/env/runtime"
    ];
    name = "m";
  }
