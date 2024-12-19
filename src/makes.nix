{ __nixpkgs__, makeScript, projectPath, outputs, ... }: {
  imports = [ ./cli/makes.nix ];
  jobs."/" = let makesVersion = "24.12";
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
    searchPaths.source = [ outputs."/src/cli/runtime" ];
    name = "m";
  };
}
