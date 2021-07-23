{ makeScript
, inputs
, projectPath
, ...
}:
makeScript {
  aliases = [
    "m-v21.08"
    "makes"
    "makes-v21.08"
  ];
  replace = {
    __argMakesSrc__ = projectPath "/";
  };
  entrypoint = ''
    __MAKES_SRC__=__argMakesSrc__ \
    python __argMakesSrc__/src/cli/main/__main__.py "$@"
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
