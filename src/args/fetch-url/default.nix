{ __nixpkgs__, fakeSha256, ... }:
{ url, sha256 ? fakeSha256, }:
__nixpkgs__.fetchurl {
  inherit sha256;
  inherit url;
}
