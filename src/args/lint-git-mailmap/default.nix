{ __nixpkgs__
, fetchGithub
, makeScript
, ...
}:
{ name
, src
}:
let
  mailmapLinter = fetchGithub {
    commit = "e0799aa47ac5ce6776ca8581ba50ace362e5d0ce";
    owner = "kamadorueda";
    repo = "mailmap-linter";
  };
in
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argSrc__ = src;
  };
  name = "lint-git-mailmap-for-${name}";
  searchPaths = {
    bin = [
      (import mailmapLinter {
        nixpkgs = __nixpkgs__;
      })
    ];
  };
}
