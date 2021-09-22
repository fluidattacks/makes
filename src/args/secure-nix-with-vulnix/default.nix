{ __nixpkgs__
, __nixpkgsSrc__
, fetchGithub
, makeScript
, toBashArray
, toFileToml
, ...
}:
{ name
, derivations
, whitelist
}:
let
  vulnixSrc = fetchGithub {
    owner = "flyingcircusio";
    repo = "vulnix";
    rev = "06daccda0e51098fbdbc65f61b6663c5c6df9358";
    sha256 = "1x22d4d89f77b3jbn7y97308j157fc92qykm4z0i4qrqsvbwqwqb";
  };
  vulnix = import vulnixSrc {
    nixpkgs = __nixpkgsSrc__;
    pkgs = __nixpkgs__;
  };
in
makeScript {
  name = "secure-nix-with-vulnix-for-${name}";
  entrypoint = ./entrypoint.sh;
  replace = {
    __argDerivations__ = toBashArray derivations;
    __argWhitelist__ = toFileToml "whitelist.toml" whitelist;
  };
  searchPaths = {
    bin = [ __nixpkgs__.nix vulnix ];
  };
}
