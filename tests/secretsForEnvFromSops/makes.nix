{
  secretsForEnvFromSops = {
    example = {
      manifest = "/tests/secretsForGpgFromEnv/secrets.yaml";
      vars = [ "secret" ];
    };
  };
}
