{ fetchArchive
, ...
}:
{ rev
, owner
, repo
, sha256
}:
fetchArchive {
  inherit sha256;
  url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
}
