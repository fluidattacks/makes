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
  replace = {
    __argSrc__ = path "/src";
  };
  entrypoint = ''
    _EVALUATOR=__argSrc__/evaluator \
    python -m cli.main "$@"
  '';
  searchPaths = {
    bin = [
      inputs.nixpkgs.git
      inputs.nixpkgs.gnutar
      inputs.nixpkgs.gzip
      inputs.nixpkgs.nix
      inputs.nixpkgs.python38
    ];
    pythonPackage = [
      (path "/src")
    ];
  };
  name = "m";
}
