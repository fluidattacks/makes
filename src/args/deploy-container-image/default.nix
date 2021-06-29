{ makeEntrypoint
, ...
}:
{ containerImage
, name
, registry
, tag
}:
makeEntrypoint {
  arguments = {
    envContainerImage = containerImage;
    envRegistry = registry;
    envTag = "${registry}/${tag}";
  };
  entrypoint = ./entrypoint.sh;
  inherit name;
  searchPaths = {
    envPaths = [
      pkgs.skopeo
    ];
  };
}
