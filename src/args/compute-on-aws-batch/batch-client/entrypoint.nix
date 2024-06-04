{ makes_inputs, nixpkgs, }:
let
  nix-filter = let
    src = builtins.fetchTarball {
      sha256 = "sha256:155cmq1w8s5v2l4d5zlhbph8r4fh0k2cl503z94ma7yizmmx9ll5";
      url =
        "https://api.github.com/repos/numtide/nix-filter/tarball/fc282c5478e4141842f9644c239a41cfe9586732";
    };
  in import src;
  python_version = "python311";
  out = import ./build {
    inherit makes_inputs python_version;
    nixpkgs = nixpkgs // { inherit nix-filter; };
    src = nix-filter {
      root = ./.;
      include = [ "batch_client" "tests" "pyproject.toml" "mypy.ini" ];
    };
  };
in out
