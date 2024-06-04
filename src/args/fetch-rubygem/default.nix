{ fakeSha256, fetchUrl, ... }:
{ sha256 ? fakeSha256, url, ... }:
fetchUrl {
  inherit sha256;
  inherit url;
}
