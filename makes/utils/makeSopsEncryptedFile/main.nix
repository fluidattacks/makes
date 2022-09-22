# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeScript,
  projectPath,
  ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  name = "make-sops-encrypted-file";
  replace = {
    __argTemplate__ = projectPath "/makes/utils/makeSopsEncryptedFile/template.yaml";
  };
  searchPaths.bin = [
    __nixpkgs__.sops
  ];
}
