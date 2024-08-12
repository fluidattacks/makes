{ __nixpkgs__, makeScript, ... }:
{ credentials, image, name, setup, sign, src }:
makeScript {
  replace = {
    __argCredentialsToken__ = credentials.token;
    __argCredentialsUser__ = credentials.user;
    __argImage__ = image;
    __argSign__ = sign;
    __argSrc__ = src;
  };
  entrypoint = ./entrypoint.sh;
  inherit name;
  searchPaths = {
    bin = [ __nixpkgs__.cosign __nixpkgs__.skopeo ];
    source = setup;
  };
}
