{ makeScript
, inputs
, path
, ...
}:
makeScript {
  arguments = {
    envNix = inputs.makesPackages.nixpkgs.nix;
    envSrc = path "/src";
  };
  entrypoint = ''
    _EVALUATOR=__envSrc__/evaluator.nix \
    _MAKES_VERSION=21.08-pre1 \
    _NIX_BUILD=__envNix__/bin/nix-build \
    _NIX_INSTANTIATE=__envNix__/bin/nix-instantiate \
    python -m cli "$@"
  '';
  searchPaths = {
    envPaths = [
      inputs.makesPackages.nixpkgs.gnutar
      inputs.makesPackages.nixpkgs.gzip
      inputs.makesPackages.nixpkgs.python38
    ];
    envPythonPaths = [
      (path "/src")
    ];
  };
  name = "m";
}
