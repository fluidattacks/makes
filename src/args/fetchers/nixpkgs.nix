{ fakeSha256
, fetchZip
, ...
}:
{ rev
, sha256 ? fakeSha256
, acceptAndroidSdkLicense ? true
, overlays ? [ ]
}:
let
  src = fetchZip {
    inherit sha256;
    url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
  };
in
import src {
  config = {
    allowUnfree = true;
    android_sdk = {
      accept_license = acceptAndroidSdkLicense;
    };
  };
  inherit overlays;
}
