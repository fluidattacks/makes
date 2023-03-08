{
  makeScript,
  outputs,
  ...
}:
makeScript {
  name = "docs";
  entrypoint = ./entrypoint.sh;
  searchPaths.source = [outputs."/docs/runtime"];
}
