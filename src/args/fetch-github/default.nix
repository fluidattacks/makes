{ fakeSha256
, fetchArchive
, ...
}:
{ rev
, owner
, repo
, sha256 ? fakeSha256
}:
fetchArchive {
  inherit sha256;
  url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
}
