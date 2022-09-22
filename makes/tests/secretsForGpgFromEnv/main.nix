# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  makeScript,
  outputs,
  ...
}:
makeScript {
  entrypoint = "echo $secret";
  name = "tests-secrets-for-gpg-from-env";
  searchPaths.source = [
    outputs."/envVars/example"
    outputs."/secretsForGpgFromEnv/example"
    outputs."/secretsForEnvFromSops/example"
  ];
}
