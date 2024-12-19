{ makeScript, outputs, ... }: {
  jobs."/docs/deploy" = makeScript {
    name = "docs-deploy";
    entrypoint = ./entrypoint.sh;
    searchPaths.source = [ outputs."/docs/runtime" ];
  };
}
