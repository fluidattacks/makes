{ __nixpkgs__, fetchGithub, makeScript, ... }:
{ name, src, exclude, }:
let
  mailmapLinter = fetchGithub {
    owner = "kamadorueda";
    repo = "mailmap-linter";
    rev = "ffed6a68e507228d7e462642a8ec129f816b6a5d";
    sha256 = "XHmqLTT7TZ/dXBtQSH1xkEGSWI4mpImt+KRqBHbfGLk=";
  };
in makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argSrc__ = src;
    __argExclude__ = exclude;
  };
  name = "lint-git-mailmap-for-${name}";
  searchPaths = {
    bin = [ (import mailmapLinter { nixpkgs = __nixpkgs__; }) ];
  };
}
