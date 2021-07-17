{ fetchGithub
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
    rev = "5ae9d2654375afb76dfb3087b1e9b200257331a2";
    sha256 = "124pka1mf25mwlzip3fa66l73zc3x0zmba5vkd7p7c521hz9xphi";
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
      (import mailmapLinter)
    ];
  };
}
