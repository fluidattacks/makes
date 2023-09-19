{
  nixpkgs,
  python_version,
}: let
  src = builtins.fetchGit {
    url = "https://gitlab.com/dmurciaatfluid/arch_lint";
    rev = "72a495bb933f052ad812292b468ca3e18fd9dde4";
    ref = "refs/tags/2.4.0+1";
  };
in
  import "${src}/build" {
    inherit nixpkgs python_version src;
  }
