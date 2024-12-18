{ computeOnAwsBatch, ... }: {
  jobs."/tests/computeOnAwsBatch" = computeOnAwsBatch {
    dryRun = true;
    allowDuplicates = true;
    attempts = 1;
    attemptDurationSeconds = 60;
    command = [ "foo" ];
    definition = "foo";
    environment = [ ];
    includePositionalArgsInName = true;
    name = "foo";
    nextJob = { };
    memory = 1;
    parallel = 1;
    propagateTags = true;
    queue = "foo";
    setup = [ ];
    tags = { };
    vcpus = 1;
  };
}
