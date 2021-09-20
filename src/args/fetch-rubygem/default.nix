{ fakeSha256
, fetchUrl
, ...
}:
{ name
, sha256 ? fakeSha256
, version
}:
fetchUrl {
  url = "https://rubygems.org/downloads/${name}-${version}.gem";
  inherit sha256;
}
