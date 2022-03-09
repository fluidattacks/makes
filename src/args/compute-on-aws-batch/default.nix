{
  __nixpkgs__,
  makeScript,
  toFileJson,
  ...
}: {
  allowDuplicates,
  attempts,
  attemptDurationSeconds,
  command,
  definition,
  environment,
  includePositionalArgsInName,
  memory,
  queue,
  name,
  setup,
  vcpus,
}:
makeScript {
  name = "compute-on-aws-batch-for-${name}";
  replace = {
    __argAllowDuplicates__ = allowDuplicates;
    __argAttempts__ = attempts;
    __argAttemptDurationSeconds__ = attemptDurationSeconds;
    __argCommand__ = toFileJson "command.json" command;
    __argDefinition__ = definition;
    __argIncludePositionalArgsInName__ = includePositionalArgsInName;
    __argManifest__ = toFileJson "manifest.json" {
      environment = builtins.concatLists [
        [
          {
            name = "CI";
            value = "true";
          }
        ]
        [
          {
            name = "MAKES_AWS_BATCH_COMPAT";
            value = "true";
          }
        ]
        (builtins.map
          (name: {
            inherit name;
            value = "\${${name}}";
          })
          environment)
      ];
      inherit memory;
      inherit vcpus;
    };
    __argName__ = name;
    __argQueue__ = queue;
  };
  searchPaths = {
    bin = [
      __nixpkgs__.awscli
      __nixpkgs__.gnugrep
      __nixpkgs__.envsubst
      __nixpkgs__.gnused
      __nixpkgs__.jq
    ];
    source = setup;
  };
  entrypoint = ./entrypoint.sh;
}
