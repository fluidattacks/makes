{ lib, makes_inputs, nixpkgs, python_pkgs, python_version, }:
let
  commit = "fd64a300bda15c2389f5bfb314f48fb5b2a0e47a"; # 2.4.0+2
  raw_src = builtins.fetchTarball {
    sha256 = "sha256:0g1md5fiyzqi9xfh1qxf0mh32k8nb06w0yhc17rr5a0ijiskb8i4";
    url =
      "https://gitlab.com/dmurciaatfluid/arch_lint/-/archive/${commit}/arch_lint-${commit}.tar";
  };
  src = import "${raw_src}/build/filter.nix" nixpkgs.nix-filter raw_src;
  bundle = import "${raw_src}/build" {
    makesLib = makes_inputs;
    inherit nixpkgs python_version src;
  };
in bundle.build_bundle (default: required_deps: builder:
  builder lib
  (required_deps (python_pkgs // { inherit (default.python_pkgs) grimp; })))
