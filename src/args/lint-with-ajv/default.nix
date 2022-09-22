# SPDX-FileCopyrightText: 2022 Fluid Attacks and Makes contributors
#
# SPDX-License-Identifier: MIT
{
  makeDerivation,
  makeNodeJsEnvironment,
  toBashArray,
  ...
}: {
  name,
  schema,
  targets,
}:
makeDerivation {
  env = {
    envSchema = schema;
    envTargets = toBashArray targets;
  };
  name = "lint-with-ajv-for-${name}";
  searchPaths = {
    source = [
      (makeNodeJsEnvironment {
        name = "ajv-cli";
        nodeJsVersion = "16";
        packageJson = ./ajv-cli/package.json;
        packageLockJson = ./ajv-cli/package-lock.json;
      })
    ];
  };
  builder = ./builder.sh;
}
