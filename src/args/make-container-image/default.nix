# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
# https://grahamc.com/blog/nix-and-layered-docker-images
# https://github.com/moby/moby/blob/master/image/spec/v1.2.md#image-json-field-descriptions
{__nixpkgs__, ...}: {
  config ? null,
  extraCommands ? "",
  layered ? true,
  layers ? [],
  maxLayers ? 65,
  runAsRoot ? null,
}: let
  sharedAttrs = {
    inherit config;
    contents = layers;
    created = "1970-01-01T00:00:01Z";
    name = "container-image";
    tag = "latest";
  };
in
  if layered
  then
    __nixpkgs__.dockerTools.buildLayeredImage
    (sharedAttrs
      // {
        inherit extraCommands;
        inherit maxLayers;
      })
  else
    __nixpkgs__.dockerTools.buildImage
    (sharedAttrs
      // {
        inherit runAsRoot;
      })
