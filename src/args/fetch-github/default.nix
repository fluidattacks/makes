{ commit
, owner
, repo
}:
builtins.fetchGit {
  url = "https://github.com/${owner}/${repo}";
  rev = commit;
}
