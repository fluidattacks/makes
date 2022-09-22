# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  inputs,
  outputs,
  projectIdentifier,
  projectSrc,
  stateDirs,
  system,
  ...
}: let
  agnostic = import ./agnostic.nix {
    inherit stateDirs;
    inherit system;
  };

  args =
    agnostic
    // {
      inherit inputs;
      inherit outputs;
      inherit projectIdentifier;
      inherit projectSrc;
      projectPath = import ./project-path/default.nix args;
      projectPathLsDirs = import ./project-path-ls-dirs/default.nix args;
      projectPathsMatching = import ./project-paths-matching/default.nix args;
      projectSrcInStore = builtins.path {
        name = "head";
        path = projectSrc;
      };
    };
in
  args
