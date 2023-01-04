{
  fakeSha256,
  fetchGithub,
  ...
}: {
  rev,
  acceptAndroidSdkLicense ? true,
  allowUnfree ? true,
  overlays ? [],
  sha256 ? fakeSha256,
}:
import
(fetchGithub {
  inherit rev;
  owner = "nixos";
  repo = "nixpkgs";
  inherit sha256;
})
{
  config = {
    inherit allowUnfree;
    android_sdk = {
      accept_license = acceptAndroidSdkLicense;
    };
  };
  inherit overlays;
}
