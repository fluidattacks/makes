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
        nodeJsVersion = "21";
        packageJson = ./ajv-cli/package.json;
        packageLockJson = ./ajv-cli/package-lock.json;
      })
    ];
  };
  builder = ./builder.sh;
}
