# https://github.com/casey/just
set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

m *ARGS:
  nix-build --show-trace
  ./result/bin/m {{ARGS}}

ma:
  just m . __all__

update:
  cd src && niv update
