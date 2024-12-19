{ __nixpkgs__, makeSearchPaths, outputs, ... }: {
  jobs."/cli/env/runtime" = makeSearchPaths {
    bin = [
      __nixpkgs__.cachix
      __nixpkgs__.findutils
      __nixpkgs__.git
      __nixpkgs__.gnutar
      __nixpkgs__.gzip
      __nixpkgs__.nixVersions.nix_2_15
      __nixpkgs__.openssh
    ];
    source = [ outputs."/cli/env/runtime/pypi" ];
  };
}
