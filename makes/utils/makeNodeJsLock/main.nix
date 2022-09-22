# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeNodeJsVersion,
  makeScript,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-node-js-lock";
  replace = {
    __argNode14__ = makeNodeJsVersion "14";
    __argNode16__ = makeNodeJsVersion "16";
    __argNode18__ = makeNodeJsVersion "18";
  };
}
