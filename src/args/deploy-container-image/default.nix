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
  arguments = {
    envContainerImage = containerImage;
    envRegistry = registry;
    envTag = "${registry}/${tag}";
  };
  entrypoint = ./entrypoint.sh;
  inherit name;
  searchPaths = {
    envPaths = [
      __nixpkgs__.skopeo
    ];
  };
}
