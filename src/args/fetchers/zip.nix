{ inputs
, ...
}:
{ url
, sha256 ? fakeSha256
}:
inputs.makesPackages.nixpkgs.fetchzip {
  inherit sha256;
  inherit url;
}
