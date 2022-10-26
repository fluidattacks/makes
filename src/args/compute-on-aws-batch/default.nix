# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
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
  parallel,
  propagateTags,
  queue,
  name,
  setup,
  tags,
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
      resourceRequirements = [
        {
          type = "VCPU";
          value = toString vcpus;
        }
        {
          type = "MEMORY";
          value = toString memory;
        }
      ];
    };
    __argName__ = name;
    __argParallel__ = parallel;
    __argPropagate__ = propagateTags;
    __argQueue__ = queue;
    __argTags__ = let
      tag_names = builtins.attrNames tags;
      encode_tag = key: "${key}=${tags."${key}"}";
      encoded = map encode_tag tag_names;
      encoded_tags = builtins.concatStringsSep "," encoded;
    in
      encoded_tags;
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
