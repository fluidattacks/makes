# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  inputs,
  makeScript,
  ...
}:
makeScript {
  name = "docs";
  entrypoint = ./entrypoint.sh;
  searchPaths.bin = [
    inputs.nixpkgs.mdbook
    inputs.nixpkgs.mdbook-mermaid
  ];
}
