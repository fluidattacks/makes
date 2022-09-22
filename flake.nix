# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  description = "A DevSecOps framework powered by Nix!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    makes = import ./default.nix {system = "x86_64-linux";};

    lib.flakes.evaluate = {
      inputs,
      system,
    }: let
      evaluated = import ./src/evaluator/default.nix {
        flakeInputs = inputs;
        makesSrc = inputs.makes.outPath;
        projectSrc = inputs.self.sourceInfo.outPath;
        inherit system;
      };
      evaluatedOutputs =
        nixpkgs.lib.mapAttrs'
        (output: value: {
          name = "config:outputs:${output}";
          inherit value;
        })
        evaluated.config.outputs;
    in {
      __makes__ =
        evaluatedOutputs
        // {
          "config:configAsJson" = evaluated.config.configAsJson;
        };
    };
  in
    (lib.flakes.evaluate {
      inputs = inputs // {makes = self;};
      system = "x86_64-linux";
    })
    // {
      inherit lib;

      defaultPackage.x86_64-linux = makes;

      defaultApp.x86_64-linux.program = "${makes}/bin/m";
      defaultApp.x86_64-linux.type = "app";
    };
}
