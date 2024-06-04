{ __nixpkgs__, makePythonPyprojectPackage, makeScript, toFileJson, ...
}@makes_inputs:
{ allowDuplicates, attempts, attemptDurationSeconds, command, definition, dryRun
, environment, includePositionalArgsInName, name, nextJob, memory, parallel
, propagateTags, queue, setup, tags, vcpus, }@self:
let
  batch-client = import ./batch-client/entrypoint.nix {
    inherit makes_inputs;
    nixpkgs = __nixpkgs__;
  };

  ci_env_var = {
    name = "CI";
    value = "true";
  };
  compat_env_var = {
    name = "MAKES_AWS_BATCH_COMPAT";
    value = "true";
  };
  encode_envs = envs:
    builtins.concatLists [
      [ ci_env_var ]
      [ compat_env_var ]
      (builtins.map (name: { inherit name; }) envs)
      # An env var that does not have a value represents a reference to it,
      # which will then be recovered during execution
    ];

  # This should match the declared defaults on module options
  apply_defaults = { allowDuplicates ? false, attempts ? 1
    , attemptDurationSeconds, command, definition, dryRun ? false
    , environment ? [ ], includePositionalArgsInName ? true, name, nextJob ? { }
    , memory, parallel ? 1, propagateTags ? true, queue, tags ? { }, vcpus,
    }@result: {
      inherit allowDuplicates attempts attemptDurationSeconds command definition
        dryRun environment;
      inherit includePositionalArgsInName name nextJob memory parallel
        propagateTags queue tags vcpus;
    };
  encode_draft = _draft:
    let draft = apply_defaults (removeAttrs _draft [ "setup" ]);
    in {
      inherit (draft) allowDuplicates attempts attemptDurationSeconds command;
      inherit (draft)
        definition dryRun includePositionalArgsInName memory parallel;
      inherit (draft) propagateTags queue name tags vcpus;
      environment = encode_envs draft.environment;
      nextJob =
        if draft.nextJob == { } then { } else encode_draft draft.nextJob;
    };
in makeScript {
  name = "compute-on-aws-batch-for-${name}";
  replace = { __argJobs__ = toFileJson "jobs.json" (encode_draft self); };
  searchPaths = {
    bin = [ batch-client.env.runtime ];
    source = setup;
  };
  entrypoint = ./entrypoint.sh;
}
