{ __nixpkgs__, makeScript, outputs, projectPath, ... }:
let makesVersion = "24.12";
in {
  imports = [
    ./cli/env/runtime/makes.nix
    ./cli/env/runtime/pypi/makes.nix
    ./container-image/makes.nix
    ./tests/commitlint/makes.nix
    ./tests/computeOnAwsBatch/makes.nix
    ./tests/makeScript/makes.nix
    ./tests/makeSearchPaths/makes.nix
    ./tests/makeTemplate/makes.nix
    ./tests/secretsForGpgFromEnv/makes.nix
    ./utils/makePythonLock/makes.nix
    ./utils/makeRubyLock/makes.nix
  ];

  jobs."/" = makeScript {
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
  };
}
