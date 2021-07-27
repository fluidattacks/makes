{ toBashArray
, makeDerivation
, makeNodeEnvironment
, makeNodeInterpreter
, makeNodeModules
, ...
}:
{ name
, schema
, targets
}:
makeDerivation {
  env = {
    envSchema = schema;
    envTargets = toBashArray targets;
  };
  name = "lint-with-ajv-for-${name}";
  searchPaths = {
    source = [
      (makeNodeEnvironment {
        node = makeNodeInterpreter "16";
        nodeModules = makeNodeModules {
          name = "ajv-cli";
          node = makeNodeInterpreter "16";
          dependencies = [ "ajv-cli@5.0.0" ];
          subDependencies = [
            "ajv@8.6.0"
            "argparse@1.0.10"
            "balanced-match@1.0.2"
            "brace-expansion@1.1.11"
            "concat-map@0.0.1"
            "esprima@4.0.1"
            "fast-deep-equal@3.1.3"
            "fast-json-patch@2.2.1"
            "fs.realpath@1.0.0"
            "glob@7.1.7"
            "inflight@1.0.6"
            "inherits@2.0.4"
            "js-yaml@3.14.1"
            "json-schema-migrate@2.0.0"
            "json-schema-traverse@1.0.0"
            "json5@2.2.0"
            "minimatch@3.0.4"
            "minimist@1.2.5"
            "once@1.4.0"
            "path-is-absolute@1.0.1"
            "punycode@2.1.1"
            "require-from-string@2.0.2"
            "sprintf-js@1.0.3"
            "uri-js@4.4.1"
            "wrappy@1.0.2"
          ];
        };
      })
    ];
  };
  builder = ./builder.sh;
}
