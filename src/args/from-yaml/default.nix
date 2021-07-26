{ fromJson
, toFileJsonFromFileYaml
, ...
}:
expr:
fromJson (
  builtins.readFile (
    toFileJsonFromFileYaml (
      builtins.toFile "" expr
    )))
