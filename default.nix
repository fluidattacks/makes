{ system ? builtins.currentSystem
,
}:

with import ./src/args/agnostic.nix { inherit system; };

makeScript {
  aliases = [
    "m-v21.10"
    "makes"
    "makes-v21.10"
  ];
  replace = {
    __argMakesSrc__ = ./.;
    __argNixStable__ = __nixpkgs__.nixStable;
    __argNixUnstable__ = __nixpkgs__.nixUnstable;
  };
  entrypoint = ''
    __MAKES_REGISTRY__=__argMakesSrc__/src/cli/main/registry.json \
    __MAKES_SRC__=__argMakesSrc__ \
    __NIX_STABLE__=__argNixStable__ \
    __NIX_UNSTABLE__=__argNixUnstable__ \
    python __argMakesSrc__/src/cli/main/__main__.py "$@"
  '';
  searchPaths = {
    bin = [
      __nixpkgs__.cachix
      __nixpkgs__.git
      __nixpkgs__.gnutar
      __nixpkgs__.gzip
      __nixpkgs__.nixStable
      __nixpkgs__.python38
    ];
  };
  name = "m";
}
