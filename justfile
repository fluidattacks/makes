# https://github.com/casey/just
set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

m *ARGS:
  $(nix-build --show-trace)/bin/m {{ARGS}}
