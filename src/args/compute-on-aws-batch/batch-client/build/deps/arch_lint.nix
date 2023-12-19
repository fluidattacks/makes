{
  nixpkgs,
  python_version,
}: let
  commit = "72a495bb933f052ad812292b468ca3e18fd9dde4";
  src = builtins.fetchTarball {
    sha256 = "sha256:0413zl4y92dbdfmck070x7dhp5cxx66xd2pxpxg3gbhaw0yqzhqd";
    url = "https://gitlab.com/dmurciaatfluid/arch_lint/-/archive/${commit}/arch_lint-${commit}.tar";
  };
in
  import "${src}/build" {
    inherit nixpkgs python_version src;
  }
