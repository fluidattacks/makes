# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  fakeSha256,
  ...
}: {
  url,
  sha256 ? fakeSha256,
  stripRoot ? true,
}:
__nixpkgs__.fetchzip {
  inherit sha256;
  inherit url;
  inherit stripRoot;
}
