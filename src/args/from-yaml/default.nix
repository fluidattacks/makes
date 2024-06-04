{ fromJson, toFileJsonFromFileYaml, ... }:
expr:
fromJson
(builtins.readFile (toFileJsonFromFileYaml (builtins.toFile "src" expr)))
