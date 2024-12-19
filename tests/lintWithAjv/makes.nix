{
  lintWithAjv = {
    "test" = {
      schema = "/tests/lintWithAjv/schema.json";
      targets =
        [ "/tests/lintWithAjv/data.json" "/tests/lintWithAjv/data.yaml" ];
    };
  };
}
