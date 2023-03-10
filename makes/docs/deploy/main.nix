{
  makeScript,
  outputs,
  ...
}:
makeScript {
  name = "docs-deploy";
  entrypoint = ./entrypoint.sh;
  searchPaths.source = [outputs."/docs/runtime"];
}
