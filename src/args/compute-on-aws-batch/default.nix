{ __nixpkgs__
, makeScript
, toFileJson
, ...
}:
{ environment ? [ ]
, jobAttempts ? 1
, jobAttemptDurationSeconds
, jobCommand
, jobDefinition
, jobMemory
, jobName ? name
, jobQueue
, jobVcpus
, name
, setup ? [ ]
}:
makeScript {
  name = "compute-on-aws-batch-for-${name}";
  replace = {
    __argJobAttempts__ = jobAttempts;
    __argJobAttemptDurationSeconds__ = jobAttemptDurationSeconds;
    __argJobCommand__ = toFileJson "command.json" jobCommand;
    __argJobDefinition__ = jobDefinition;
    __argJobManifest__ = toFileJson "manifest.json" {
      environment = builtins.concatLists [
        [{ name = "CI"; value = "true"; }]
        (builtins.map
          (name: { inherit name; value = "\${${name}}"; })
          (environment))
      ];
      memory = jobMemory;
      vcpus = jobVcpus;
    };
    __argJobName__ = jobName;
    __argJobQueue__ = jobQueue;
  };
  searchPaths = {
    bin = [
      __nixpkgs__.awscli
      __nixpkgs__.envsubst
      __nixpkgs__.jq
    ];
    source = setup;
  };
  entrypoint = ./entrypoint.sh;
}
