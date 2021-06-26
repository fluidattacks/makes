{ makeDerivation
, makeEntrypoint
, makeTemplate
, ...
}:
{
  a = makeDerivation {
    builder = "touch $out";
    name = "test";
  };
  b = makeTemplate {
    arguments = {
      envVar = "123";
    };
    name = "test";
    template = "__envVar__";
  };
  c = makeEntrypoint {
    entrypoint = "echo Hello from Makes!";
    name = "c";
  };
}
