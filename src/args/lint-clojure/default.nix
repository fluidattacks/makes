# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  __nixpkgs__,
  makeDerivation,
  makeDerivationParallel,
  ...
}: {
  targets,
  name,
  ...
}: let
  makeTarget = envTarget:
    makeDerivation {
      env = {
        inherit envTarget;
      };
      name = "build-lint-clojure-for-${name}-${envTarget}";
      searchPaths.bin = [__nixpkgs__.clj-kondo];
      builder = ./builder.sh;
    };
in
  makeDerivationParallel {
    dependencies = builtins.map makeTarget targets;
    name = "lint-clojure-for-${name}";
  }
