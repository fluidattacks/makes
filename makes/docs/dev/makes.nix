{ makeScript, outputs, ... }: {
  jobs."/docs/dev" = makeScript {
    name = "docs-dev";
    entrypoint = ./entrypoint.sh;
    searchPaths.source = [ outputs."/docs/runtime" ];
  };
}
