# https://github.com/casey/just
set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

m *ARGS:
  CACHIX_AUTH_TOKEN="${CACHIX_MAKES_TOKEN:-}" \
    "$(nix-build --show-trace --no-out-link)/bin/m" {{ARGS}}

ma:
  just m . __all__

update:
  cd src && niv update
