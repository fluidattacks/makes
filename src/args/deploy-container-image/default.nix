{ __nixpkgs__, makeScript, ... }:
{ attempts ? 1, containerImage, credentials, name, registry, setup, sign, tag,
}:
makeScript {
  replace = {
    __argAttempts__ = attempts;
    __argContainerImage__ = containerImage;
    __argCredentialsToken__ = credentials.token;
    __argCredentialsUser__ = credentials.user;
    __argRegistry__ = registry;
    __argSign__ = sign;
    __argTag__ = "${registry}/${tag}";
  };
  entrypoint = ./entrypoint.sh;
  inherit name;
  searchPaths = {
    bin = [ __nixpkgs__.cosign __nixpkgs__.skopeo ];
    source = setup;
  };
}
