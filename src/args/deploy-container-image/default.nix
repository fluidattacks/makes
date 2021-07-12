{ __nixpkgs__
, makeScript
, ...
}:
{ containerImage
, name
, registry
, tag
}:
makeScript {
  replace = {
    __argContainerImage__ = containerImage;
    __argRegistry__ = registry;
    __argTag__ = "${registry}/${tag}";
  };
  entrypoint = ./entrypoint.sh;
  inherit name;
  searchPaths = {
    bin = [
      __nixpkgs__.skopeo
    ];
  };
}
