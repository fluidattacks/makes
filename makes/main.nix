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
    envNix = inputs.nixpkgs.nix;
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
      inputs.nixpkgs.git
      inputs.nixpkgs.gnutar
      inputs.nixpkgs.gzip
      inputs.nixpkgs.python38
    ];
    envPythonPaths = [
      (path "/src")
    ];
  };
  name = "m";
}
