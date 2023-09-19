{
  nixpkgs,
  python_version,
}: let
  src = builtins.fetchGit {
    url = "https://gitlab.com/dmurciaatfluid/purity";
    rev = "e0b5cf459a16eb92d86ca6c024edbedd52d72589";
    ref = "refs/tags/v1.38.0";
  };
in
  import "${src}/build" {
    inherit src nixpkgs python_version;
  }
