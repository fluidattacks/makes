{ makeScript
, inputs
, path
, ...
}:
let
  version = inputs.version;
in
makeScript {
  aliases = [
    "m-v${version}"
    "makes"
    "makes-v${version}"
  ];
  arguments = {
    envNix = inputs.makesPackages.nixpkgs.nix;
    envSrc = path "/src";
  };
  entrypoint = ''
    _EVALUATOR=__envSrc__/evaluator.nix \
    _MAKES_VERSION=${version} \
    _NIX_BUILD=__envNix__/bin/nix-build \
    _NIX_INSTANTIATE=__envNix__/bin/nix-instantiate \
    python __envSrc__/cli.py "$@"
  '';
  searchPaths = {
    envPaths = [
      inputs.makesPackages.nixpkgs.gnutar
      inputs.makesPackages.nixpkgs.gzip
      inputs.makesPackages.nixpkgs.python38
    ];
  };
  name = "m";
}
