{
  description = "A DevSecOps framework powered by Nix!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { nixpkgs, ... }:
    let makes = import ./default.nix { system = "x86_64-linux"; };
    in
    {
      defaultPackage.x86_64-linux = makes;

      defaultApp.x86_64-linux.program = "${makes}/bin/m";
      defaultApp.x86_64-linux.type = "app";

      lib.flakes.evaluate =
        { inputs
        , system
        }:
        let
          evaluated = import ./src/evaluator/default.nix {
            # TODO: Deprecate this
            makesExecutionId = "123";
            makesSrc = inputs.makes.outPath;
            projectSrc = inputs.self.sourceInfo.outPath;
            # TODO: Make it mutable
            projectSrcMutable = inputs.self.sourceInfo.outPath;
            inherit system;
          };
          evaluatedOutputs = nixpkgs.lib.mapAttrs'
            (output: value: {
              name = "makes:config:outputs:${output}";
              inherit value;
            })
            evaluated.config.outputs;
        in
        evaluatedOutputs // {
          "makes:config:attrs" = evaluated.config.attrs;
          "makes:config:cacheAsJson" = evaluated.config.cacheAsJson;
        };
    };
}
