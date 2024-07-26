{ __nixpkgs__, makeScript, toFileYaml, ... }:
{ config, credentials, name, setup, sign }:
makeScript {
  replace = {
    __argConfig__ = toFileYaml "manifest.yaml " config;
    __argCredentialsToken__ = credentials.token;
    __argCredentialsUser__ = credentials.user;
    __argSign__ = sign;
  };
  entrypoint = ./entrypoint.sh;
  inherit name;
  searchPaths = {
    bin = [ __nixpkgs__.cosign __nixpkgs__.manifest-tool __nixpkgs__.yq ];
    source = setup;
  };
}
