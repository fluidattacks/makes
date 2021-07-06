{ makeScript
, inputs
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
      inputs.makesPackages.nixpkgs.skopeo
    ];
  };
}
