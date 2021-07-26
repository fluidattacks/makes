{ __toModuleOutputs__
, asBashArray
, asBashMap
, makeScript
, outputs
, ...
}:
{ config
, lib
, ...
}:
let
  jobType = lib.types.submodule (_: {
    options = {
      args = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
      };
      output = lib.mkOption {
        type = lib.types.str;
      };
    };
  });

  pipelineType = lib.types.submodule (_: {
    options = {
      jobs = lib.mkOption {
        default = { };
        type = lib.types.listOf jobType;
      };
    };
  });

  makeJob = { output, args }:
    let
      name = builtins.toString ([ output ] ++ args);
    in
    {
      inherit name;
      value = makeScript {
        replace = {
          __argArgs__ = asBashArray args;
          __argOutput__ = outputs.${output};
        };
        name = "job-for-${name}";
        entrypoint = ./entrypoint-for-job.sh;
      };
    };

  makePipeline = name: { jobs }: {
    name = "/pipeline/${name}";
    value = makeScript {
      entrypoint = ./entrypoint-for-pipeline.sh;
      replace = {
        __argJobs__ = asBashMap
          (builtins.listToAttrs (builtins.map makeJob jobs));
      };
      name = "pipeline-for-${name}";
    };
  };
in
{
  options = {
    pipelines = lib.mkOption {
      default = { };
      type = lib.types.attrsOf pipelineType;
    };
  };
  config = {
    outputs = __toModuleOutputs__ makePipeline config.pipelines;
  };
}
