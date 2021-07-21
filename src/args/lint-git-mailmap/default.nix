{ __nixpkgs__
, fetchGithub
, makeScript
, ...
}:
{ name
, src
, ...
}:
let
  mailmapLinter = fetchGithub {
    owner = "kamadorueda";
    repo = "mailmap-linter";
    rev = "e0799aa47ac5ce6776ca8581ba50ace362e5d0ce";
    sha256 = "02nr39rn4hicfam1rccbqhn6w6pl25xq7fl2kw0s0ahxzvfk24mh";
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
