{ makeScript
, inputs
, path
, requiredMakesVersion
, ...
}:
makeScript {
  aliases = [
    "m-v${requiredMakesVersion}"
    "makes"
    "makes-v${requiredMakesVersion}"
  ];
  arguments = {
    envNix = inputs.makesPackages.nixpkgs.nix;
    envSrc = path "/src";
  };
  entrypoint = ''
    _EVALUATOR=__envSrc__/evaluator.nix \
    _M_VERSION=${requiredMakesVersion} \
    _NIX_BUILD=__envNix__/bin/nix-build \
    _NIX_INSTANTIATE=__envNix__/bin/nix-instantiate \
    python -m cli.main "$@"
  '';
  searchPaths = {
    envPaths = [
      inputs.makesPackages.nixpkgs.git
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
