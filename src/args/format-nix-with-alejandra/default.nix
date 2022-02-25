{ __system__
, fetchGithub
, toBashArray
, makeScript
, ...
}:
{ name
, targets
, ...
}:
let
  alejandra = fetchGithub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = "8b5d2f9e5086d4bd38ca5b497127a750774dee3b";
    sha256 = "158xqn0cdnrlg61ki963whsrb4rqjs1v2pfc40a9plx8x0il81as";
  };
in
makeScript {
  replace = {
    __argTargets__ = toBashArray targets;
  };
  name = "format-nix-with-alejandra-for-${name}";
  searchPaths = {
    bin = [
      (import alejandra)."${__system__}"
    ];
  };
  entrypoint = ./entrypoint.sh;
}
