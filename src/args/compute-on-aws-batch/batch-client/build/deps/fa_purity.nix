{
  nixpkgs,
  python_version,
}: let
  commit = "e0b5cf459a16eb92d86ca6c024edbedd52d72589";
  src = builtins.fetchTarball {
    sha256 = "sha256:08h1b94mn74lqz47cj8m5dmm5xddddfd1clrb6zqi898w3q1bylr";
    url = "https://gitlab.com/dmurciaatfluid/purity/-/archive/${commit}/purity-${commit}.tar";
  };
in
  import "${src}/build" {
    inherit src nixpkgs python_version;
  }
