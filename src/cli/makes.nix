{ __nixpkgs__, makePythonEnvironment, makeSearchPaths, outputs, ... }: {
  jobs = {
    "/src/cli/runtime" = makeSearchPaths {
      bin = [
        __nixpkgs__.cachix
        __nixpkgs__.findutils
        __nixpkgs__.git
        __nixpkgs__.gnutar
        __nixpkgs__.gzip
        __nixpkgs__.nixVersions.nix_2_15
        __nixpkgs__.openssh
      ];
      source = [
        (makePythonEnvironment {
          pythonProjectDir = ./.;
          pythonVersion = "3.11";
        })
      ];
    };
  };
}
