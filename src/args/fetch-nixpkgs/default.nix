{ fetchGithub
, ...
}:
{ commit
, acceptAndroidSdkLicense ? true
, allowUnfree ? true
, overlays ? [ ]
}:
import
  (fetchGithub {
    inherit commit;
    owner = "nixos";
    repo = "nixpkgs";
  })
  ({
    config = {
      inherit allowUnfree;
      android_sdk = {
        accept_license = acceptAndroidSdkLicense;
      };
    };
    inherit overlays;
  })
