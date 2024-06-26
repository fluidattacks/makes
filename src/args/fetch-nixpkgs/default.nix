{ fakeSha256, ... }:
{ rev, acceptAndroidSdkLicense ? true, allowUnfree ? true, overlays ? [ ]
, sha256 ? fakeSha256, }:
import (builtins.fetchTarball {
  url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
  inherit sha256;
}) {
  config = {
    inherit allowUnfree;
    android_sdk = { accept_license = acceptAndroidSdkLicense; };
  };
  inherit overlays;
}
