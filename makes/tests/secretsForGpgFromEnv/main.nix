{ makeScript, outputs, ... }:
makeScript {
  entrypoint = "echo $secret";
  name = "tests-secrets-for-gpg-from-env";
  searchPaths.source = [
    outputs."/envVars/example"
    outputs."/secretsForGpgFromEnv/example"
    outputs."/secretsForEnvFromSops/example"
  ];
}
