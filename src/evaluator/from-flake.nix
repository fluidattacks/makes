{ inputs
, system
, ...
}:
let
  evaluatorOutputs = import ./default.nix {
    # TODO: How to compute this on Flakes?
    makesExecutionId = "123";
    makesSrc = inputs.makes.outPath;
    projectSrc = inputs.self.sourceInfo.outPath;
    # TODO: Make it mutable
    projectSrcMutable = inputs.self.sourceInfo.outPath;
    inherit system;
  };

  packages = evaluatorOutputs.config.outputs;
in
{
  inherit packages;
}
