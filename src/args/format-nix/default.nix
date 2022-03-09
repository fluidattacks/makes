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
    rev = "1.0.0";
    sha256 = "14n9qrfrzwz3aclal35rsmg70s876whggcrs8h4v7r9q4lfxd7vw";
  };
in
makeScript {
  replace = {
    __argTargets__ = toBashArray targets;
  };
  name = "format-nix-for-${name}";
  searchPaths = {
    bin = [
      (import alejandra)."${__system__}"
    ];
  };
  entrypoint = ./entrypoint.sh;
}
