# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeScript,
  ...
}: {
  attempts ? 1,
  containerImage,
  credentials,
  name,
  registry,
  setup,
  tag,
}:
makeScript {
  replace = {
    __argUser__ = credentials.user;
    __argToken__ = credentials.token;
    __argContainerImage__ = containerImage;
    __argTag__ = "${registry}/${tag}";
    __argAttempts__ = attempts;
  };
  entrypoint = ./entrypoint.sh;
  inherit name;
  searchPaths = {
    bin = [
      __nixpkgs__.skopeo
    ];
    source = setup;
  };
}
