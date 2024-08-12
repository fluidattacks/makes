{ __nixpkgs__, makeScript, toFileYaml, ... }:
{ credentials, image, manifests, name, setup, sign, tags }:
makeScript {
  replace = {
    __argConfig__ =
      toFileYaml "manifest.yaml " { inherit image manifests tags; };
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
