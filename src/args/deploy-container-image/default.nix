{ __nixpkgs__
, makeScript
, ...
}:
{ attempts ? 1
, containerImage
, name
, registry
, tag
}:
makeScript {
  replace = {
    __argContainerImage__ = containerImage;
    __argRegistry__ = registry;
    __argTag__ = "${registry}/${tag}";
    __argAttempts__ = attempts;
  };
  entrypoint = ./entrypoint.sh;
  inherit name;
  searchPaths = {
    bin = [
      __nixpkgs__.skopeo
    ];
  };
}
