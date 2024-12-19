{ makeScript, outputs, ... }: {
  jobs."/tests/secretsForGpgFromEnv" = makeScript {
    entrypoint = "echo $secret";
    name = "tests-secrets-for-gpg-from-env";
    searchPaths.source = [
      outputs."/envVars/example"
      outputs."/secretsForGpgFromEnv/example"
      outputs."/secretsForEnvFromSops/example"
    ];
  };
}
