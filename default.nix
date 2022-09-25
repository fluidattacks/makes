# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{system ? builtins.currentSystem}: let
  agnostic = import ./src/args/agnostic.nix {inherit system;};

  args =
    agnostic
    // {
      outputs."/cli/env/runtime" =
        import ./makes/cli/env/runtime/main.nix args;
      outputs."/cli/env/runtime/pypi" =
        import ./makes/cli/env/runtime/pypi/main.nix args;
      projectPath = import ./src/args/project-path args;
      projectSrc = ./.;
    };
in
  import ./makes/main.nix args
