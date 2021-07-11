{ makeScript
, inputs
, path
, ...
}:
makeScript {
  aliases = [
    "m-v21.08"
    "makes"
    "makes-v21.08"
  ];
  arguments = {
    envNix = inputs.nixpkgs.nix;
    envSrc = path "/src";
  };
  entrypoint = ''
    _EVALUATOR=__envSrc__/evaluator.nix \
    python -m cli.main "$@"
  '';
  searchPaths = {
    envPaths = [
      inputs.nixpkgs.git
      inputs.nixpkgs.gnutar
      inputs.nixpkgs.gzip
      inputs.nixpkgs.nix
      inputs.nixpkgs.python38
    ];
    envPythonPaths = [
      (path "/src")
    ];
  };
  name = "m";
}
