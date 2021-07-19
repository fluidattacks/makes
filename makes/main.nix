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
    __argCliEntrypoint__ = path "/src/cli/main/__main__.py";
    __argSrc__ = path "/src";
  };
  entrypoint = ''
    _EVALUATOR=__argSrc__/evaluator/default.nix \
    python __argCliEntrypoint__ "$@"
  '';
  searchPaths = {
    bin = [
      inputs.nixpkgs.cachix
      inputs.nixpkgs.git
      inputs.nixpkgs.gnutar
      inputs.nixpkgs.gzip
      inputs.nixpkgs.nix
      inputs.nixpkgs.python38
    ];
  };
  name = "m";
}
