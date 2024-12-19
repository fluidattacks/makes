{ makeScript, outputs, ... }: {
  envVars = {
    example = {
      # Don't do this in production, it's unsafe. We do this for testing purposes.
      PGP_PRIVATE = builtins.readFile ./pgp;
      PGP_PUBLIC = builtins.readFile ./pgp.pub;
      VAR_NAME = "test";
    };
  };
  jobs."/tests/secretsForGpgFromEnv" = makeScript {
    entrypoint = "echo $secret";
    name = "tests-secrets-for-gpg-from-env";
    searchPaths.source = [
      outputs."/envVars/example"
      outputs."/secretsForGpgFromEnv/example"
      outputs."/secretsForEnvFromSops/example"
    ];
  };
  secretsForGpgFromEnv.example = [ "PGP_PUBLIC" "PGP_PRIVATE" ];
}
