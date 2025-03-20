# https://grahamc.com/blog/nix-and-layered-docker-images
# https://github.com/moby/moby/blob/master/image/spec/v1.2.md#image-json-field-descriptions
{ __nixpkgs__, ... }:
{
  layered ? true,
  name ? "container-image",
  tag ? "latest",
  created ? "1970-01-01T00:00:01Z",
  layers ? [],
  maxLayers ? 65,
  ...
}@args:
let
  defaults = {
    inherit name tag created;
  };

  # handle layers alias for contents
  layersMapping = if args ? contents then {} else { contents = layers; };

  finalAttrs = defaults // layersMapping // args;

  attrs = builtins.removeAttrs finalAttrs [ "layered" "layers" ];
in
  if layered then
    __nixpkgs__.dockerTools.buildLayeredImage attrs
  else
    __nixpkgs__.dockerTools.buildImage attrs
