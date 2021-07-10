{ fetchUrl
, ...
}:
{ rev
, sha256 ? fakeSha256
, acceptAndroidSdkLicense ? true
, overlays ? [ ]
}:
let
  src = fetchUrl {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.zip";
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
