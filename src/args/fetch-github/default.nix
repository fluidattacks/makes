{ fetchZip
, ...
}:
{ rev
, owner
, repo
, sha256
}:
fetchZip {
  inherit sha256;
  url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
}
