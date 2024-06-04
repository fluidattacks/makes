{ lib, makes_inputs, nixpkgs, python_pkgs, python_version, }:
let
  commit = "5ff1ddb203afcc0a636b0305398581845f68a153"; # v1.40.0
  raw_src = builtins.fetchTarball {
    sha256 = "sha256:1i357nzd15a7c8av0ff7495gbcfd4pc7xxprlrbnz4savwnxd5x1";
    url =
      "https://gitlab.com/dmurciaatfluid/purity/-/archive/${commit}/purity-${commit}.tar";
  };
  src = import "${raw_src}/build/filter.nix" nixpkgs.nix-filter raw_src;
  bundle = import "${raw_src}/build" {
    makesLib = makes_inputs;
    inherit nixpkgs python_version src;
  };
  more-itertools = python_pkgs.more-itertools.overrideAttrs (oldAttrs: rec {
    version = "9.1.0";
    src = lib.fetchPypi {
      pname = "more-itertools";
      inherit version;
      sha256 = "sha256-yrqjQa0DieqDwXqUVmpTrkydBzSYYeyxTcbQNFz5rF0=";
    };
  });
in bundle.build_bundle (default: required_deps: builder:
  builder lib (required_deps (python_pkgs // {
    inherit more-itertools;
  } // {
    inherit (default.python_pkgs) types-simplejson;
  })))
