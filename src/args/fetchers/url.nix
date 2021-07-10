{ inputs
, ...
}:
{ url
, sha256 ? fakeSha256
}:
inputs.makesPackages.nixpkgs.fetchurl {
  inherit sha256;
  inherit url;
}
