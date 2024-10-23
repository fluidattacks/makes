{ __nixpkgs__, makeScript, toBashArray, ... }:
{ name, schema, targets, }:
makeScript {
  replace = {
    __argSchema__ = schema;
    __argTargets__ = toBashArray targets;
    __argAjvPath__ = ./ajv-cli;
  };
  name = "lint-with-ajv-for-${name}";
  searchPaths.bin = [ __nixpkgs__.nodejs_21 ];
  entrypoint = ./entrypoint.sh;
}
