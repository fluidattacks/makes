{ fakeSha256
, fetchZip
, ...
}:
{ owner
, repo
, rev
, sha256 ? fakeSha256
}:
fetchZip {
  inherit sha256;
  url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
}
