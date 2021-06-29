{ makeEntrypoint
, inputs
, path
, ...
}:
makeEntrypoint {
  arguments = {
    envNix = inputs.makesPackages.nixpkgs.nix;
    envSrc = path "/src";
  };
  entrypoint = ''
    _EVALUATOR=__envSrc__/evaluator.nix \
    _NIX_BUILD=__envNix__/bin/nix-build \
    _NIX_INSTANTIATE=__envNix__/bin/nix-instantiate \
    python -m cli "$@"
  '';
  searchPaths = {
    envPaths = [
      inputs.makesPackages.nixpkgs.python38
    ];
    envPythonPaths = [
      (path "/src")
    ];
  };
  name = "m";
}
