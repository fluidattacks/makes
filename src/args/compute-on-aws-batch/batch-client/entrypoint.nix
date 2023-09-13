{
  makePythonPyprojectPackage,
  nixpkgs,
}: let
  nix-filter = let
    src = builtins.fetchGit {
      url = "https://github.com/numtide/nix-filter";
      rev = "fc282c5478e4141842f9644c239a41cfe9586732";
    };
  in
    import src;
  python_version = "python311";
  out = import ./build {
    inherit makePythonPyprojectPackage nixpkgs python_version;
    src = nix-filter {
      root = ./.;
      include = [
        "batch_client"
        "tests"
        "pyproject.toml"
        "mypy.ini"
      ];
    };
  };
in
  out
