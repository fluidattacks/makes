{ makeTemplate
, ...
}:
makeTemplate {
  arguments = {
    envVar = "123";
  };
  name = "test";
  template = "__envVar__";
}
