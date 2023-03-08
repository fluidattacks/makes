{
  makeScript,
  outputs,
  ...
}:
makeScript {
  name = "docs-dev";
  entrypoint = ./entrypoint.sh;
  searchPaths.source = [outputs."/docs/runtime"];
}
