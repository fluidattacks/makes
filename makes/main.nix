{ __nixpkgs__, makeScript, outputs, projectPath, ... }:
let makesVersion = "24.09";
in makeScript {
  aliases = [ "m-v${makesVersion}" "makes" "makes-v${makesVersion}" ];
  replace = {
    __argMakesSrc__ = projectPath "/";
    __argNix__ = __nixpkgs__.nixVersions.nix_2_15;
  };
  entrypoint = ''
    __MAKES_SRC__=__argMakesSrc__ \
    __NIX__=__argNix__ \
    python -u __argMakesSrc__/src/cli/main/__main__.py "$@"
  '';
  searchPaths.source = [ outputs."/cli/env/runtime" ];
  name = "m";
}
