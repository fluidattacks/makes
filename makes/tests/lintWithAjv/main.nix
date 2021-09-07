# /path/to/my/project/makes/example/main.nix
{ lintWithAjv
, ...
}:
lintWithAjv {
  name = "makes/tests/lintWithAjv";
  schema = "/makes/tests/lintWithAjv/schema.json";
  targets = [
    "/makes/tests/lintWithAjv/data.json"
    "/makes/tests/lintWithAjv/data.yaml"
  ];
}
