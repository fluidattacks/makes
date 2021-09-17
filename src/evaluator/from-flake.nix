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

  packages =
    (builtins.listToAttrs (builtins.map
      (output: {
        name = "makes:config:outputs:${output}";
        value = evaluatorOutputs.config.outputs.${output};
      })
      (builtins.attrNames evaluatorOutputs.config.outputs)))
    // {
      "makes:config:attrs" = evaluatorOutputs.config.attrs;
      "makes:config:cacheAsJson" = evaluatorOutputs.config.cacheAsJson;
    };
in
{
  inherit packages;
}
